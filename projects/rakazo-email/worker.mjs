const DOMAIN = "bots.zefirsroyal.cloud";
const MAX_EMAIL = 25 * 1024 * 1024;
const encoder = new TextEncoder();

async function boundedBody(message, limit) {
  if (Number(message.headers.get("content-length")) > limit) {
    await message.body?.cancel();
    return null;
  }
  const reader = message.body?.getReader();
  if (!reader) return new Uint8Array();
  const chunks = [];
  let length = 0;
  for (;;) {
    const { value, done } = await reader.read();
    if (done) break;
    length += value.byteLength;
    if (length > limit) {
      await reader.cancel();
      return null;
    }
    chunks.push(value);
  }
  const result = new Uint8Array(length);
  let offset = 0;
  for (const chunk of chunks) {
    result.set(chunk, offset);
    offset += chunk.byteLength;
  }
  return result;
}

function decodeBase64(value) {
  return Uint8Array.from(atob(value), (character) => character.charCodeAt(0));
}

// Svix signs the original bytes and permits several signatures during rotation.
async function verify(body, headers, secret) {
  const id = headers.get("svix-id");
  const timestamp = headers.get("svix-timestamp");
  if (!id || !/^\d+$/.test(timestamp ?? "") ||
      Math.abs(Date.now() / 1000 - Number(timestamp)) > 300) return false;
  const key = await crypto.subtle.importKey("raw", decodeBase64(secret.replace(/^whsec_/, "")),
    { name: "HMAC", hash: "SHA-256" }, false, ["verify"]);
  const prefix = encoder.encode(`${id}.${timestamp}.`);
  const signed = new Uint8Array(prefix.length + body.length);
  signed.set(prefix);
  signed.set(body, prefix.length);
  for (const signature of (headers.get("svix-signature") ?? "").split(" ")) {
    const [version, value] = signature.split(",");
    if (version !== "v1" || !value) continue;
    try {
      if (await crypto.subtle.verify("HMAC", key, decodeBase64(value), signed)) return true;
    } catch { /* A malformed candidate must not hide a later valid signature. */ }
  }
  return false;
}

async function relay(request, env) {
  const path = new URL(request.url).pathname;
  if (request.method === "GET" && path === "/health") return new Response("ok");
  if (path !== "/api/v1/email/resend") return new Response("Not found", { status: 404 });
  if (request.method !== "POST") return new Response("Method not allowed", { status: 405 });
  const payload = await boundedBody(request, 256 * 1024);
  if (!payload) return new Response("Webhook too large", { status: 413 });
  if (!await verify(payload, request.headers, env.RESEND_WEBHOOK_SECRET)) {
    return new Response("Invalid signature", { status: 401 });
  }
  let event;
  try { event = JSON.parse(new TextDecoder("utf-8", { fatal: true, ignoreBOM: false }).decode(payload)); }
  catch { return new Response("Invalid event", { status: 400 }); }
  if (!event || typeof event !== "object") return new Response("Invalid event", { status: 400 });
  if (event.type !== "email.received") return new Response("Ignored");
  if (!/^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i.test(event.data?.email_id ?? "") || !Array.isArray(event.data?.to)) {
    return new Response("Invalid received event", { status: 400 });
  }
  const recipients = [...new Set(event.data.to.filter((address) =>
    typeof address === "string" && /^[a-z0-9][a-z0-9._+-]{0,63}@bots\.zefirsroyal\.cloud$/i.test(address)
  ).map((address) => address.toLowerCase()))];
  if (!recipients.length) return new Response("Ignored domain");
  // The free Worker allows 50 subrequests: metadata, MIME, then one per recipient.
  if (recipients.length > 48) return new Response("Too many recipients", { status: 400 });

  const metadataResponse = await fetch(`https://api.resend.com/emails/receiving/${event.data.email_id}`, {
    headers: { authorization: `Bearer ${env.RESEND_API_KEY}` },
    redirect: "error", signal: AbortSignal.timeout(30000),
  });
  if (!metadataResponse.ok) throw new Error("Resend retrieval failed");
  const metadata = await metadataResponse.json();
  const rawUrl = new URL(metadata.raw.download_url);
  if (rawUrl.protocol !== "https:" || rawUrl.username || rawUrl.password || rawUrl.port ||
      ![".resend.com", ".cloudfront.net"].some((suffix) => rawUrl.hostname.endsWith(suffix))) {
    throw new Error("Unexpected raw mail host");
  }
  const rawResponse = await fetch(rawUrl, { redirect: "error", signal: AbortSignal.timeout(60000) });
  if (!rawResponse.ok) throw new Error("Raw mail retrieval failed");
  const raw = await boundedBody(rawResponse, MAX_EMAIL);
  if (!raw) {
    console.warn("Inbound email exceeds Rakazo's 25 MiB limit");
    return new Response("Ignored oversized email");
  }
  // Rakazo owns sender checks and per-bot deduplication, including partial retries.
  for (const recipient of recipients) {
    const destination = new URL(`https://${DOMAIN}/api/v1/email/inbound`);
    destination.searchParams.set("to", recipient);
    const response = await fetch(destination, {
      method: "POST", redirect: "error", signal: AbortSignal.timeout(60000),
      headers: { authorization: `Bearer ${env.INBOUND_EMAIL_SECRET}`, "content-type": "message/rfc822" },
      body: raw,
    });
    await response.body?.cancel();
    if (!response.ok && response.status !== 413) throw new Error("Rakazo delivery failed");
  }
  return new Response("Delivered");
}

export default {
  async fetch(request, env) {
    try { return await relay(request, env); }
    catch {
      // Do not log message contents, addresses, signed download URLs or credentials.
      console.error("Inbound delivery failed; requesting Resend retry");
      return new Response("Retry later", { status: 503 });
    }
  },
};
