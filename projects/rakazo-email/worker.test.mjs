import assert from "node:assert/strict";
import { createHmac } from "node:crypto";
import { test } from "node:test";
import worker from "./worker.mjs";

const env = {
  RESEND_WEBHOOK_SECRET: `whsec_${Buffer.alloc(32, 7).toString("base64")}`,
  RESEND_API_KEY: "test-resend-key",
  INBOUND_EMAIL_SECRET: "test-inbound-key",
};
const event = { type: "email.received", data: {
  email_id: "56761188-7520-42d8-8898-ff6fc54ce618",
  to: ["chief@bots.zefirsroyal.cloud"],
} };
const raw = Buffer.from("From: sender@example.net\r\nTo: chief@bots.zefirsroyal.cloud\r\nMessage-ID: <synthetic@example.net>\r\nContent-Type: multipart/mixed; boundary=x\r\n\r\n--x\r\nContent-Type: text/plain\r\n\r\nSynthetic body\r\n--x\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: base64\r\n\r\nAAECAw==\r\n--x--\r\n");

function request(value = event, options = {}) {
  const payload = typeof value === "string" ? value : JSON.stringify(value);
  const timestamp = String(options.timestamp ?? Math.floor(Date.now() / 1000));
  const signature = createHmac("sha256", Buffer.alloc(32, 7))
    .update(`synthetic-event.${timestamp}.${payload}`).digest("base64");
  return new Request("https://relay.example/api/v1/email/resend", {
    method: "POST", body: options.body ?? payload,
    headers: { "svix-id": "synthetic-event", "svix-timestamp": timestamp,
      "svix-signature": options.signature ?? `v1,${signature}` },
  });
}

function mockUpstream(t, options = {}) {
  const calls = [];
  t.mock.method(globalThis, "fetch", async (url, init) => {
    calls.push({ url: String(url), init });
    if (String(url).startsWith("https://api.resend.com/")) {
      assert.equal(init.headers.authorization, `Bearer ${env.RESEND_API_KEY}`);
      return Response.json({ raw: { download_url: options.rawUrl ?? "https://inbound-cdn.resend.com/raw/test" } },
        { status: options.metadataStatus ?? 200 });
    }
    if (String(url).startsWith("https://inbound-cdn.resend.com/")) {
      assert.equal(init.headers, undefined, "No credentials forwarded to the download host");
      return new Response(options.raw ?? raw, { headers: options.rawHeaders });
    }
    assert.equal(new URL(url).origin, "https://bots.zefirsroyal.cloud");
    assert.equal(init.headers.authorization, `Bearer ${env.INBOUND_EMAIL_SECRET}`);
    assert.equal(init.headers["content-type"], "message/rfc822");
    assert.equal(init.redirect, "error");
    assert.deepEqual(Buffer.from(init.body), raw, "MIME and attachment bytes preserved");
    return new Response("ok", { status: options.deliveryStatus ?? 200 });
  });
  return calls;
}

test("rejects tampering, missing/bad signatures and stale/future timestamps before any network request", async (t) => {
  const calls = mockUpstream(t);
  for (const req of [request(event, { body: "tampered" }), request(event, { signature: "" }),
    request(event, { signature: "v1,not-base64!" }), request(event, { timestamp: 1 }),
    request(event, { timestamp: Math.floor(Date.now() / 1000) + 601 })]) {
    assert.equal((await worker.fetch(req, env)).status, 401);
  }
  assert.equal(calls.length, 0);
});

test("forwards original MIME to unique in-domain recipients and supports signature rotation", async (t) => {
  const calls = mockUpstream(t);
  const req = request({ ...event, data: { ...event.data, to: [
    "chief@bots.zefirsroyal.cloud", "CHIEF@bots.zefirsroyal.cloud", "career@bots.zefirsroyal.cloud", "outside@example.net",
  ] } });
  req.headers.set("svix-signature", `v1,invalid! v2,unsupported ${req.headers.get("svix-signature")}`);
  assert.equal((await worker.fetch(req, env)).status, 200);
  assert.deepEqual(calls.slice(2).map((c) => new URL(c.url).searchParams.get("to")),
    ["chief@bots.zefirsroyal.cloud", "career@bots.zefirsroyal.cloud"]);
});

test("retries upstream or Rakazo failures, including authentication failure", async (t) => {
  for (const options of [{ metadataStatus: 429 }, { deliveryStatus: 503 }, { deliveryStatus: 401 }]) {
    t.mock.restoreAll();
    mockUpstream(t, options);
    assert.equal((await worker.fetch(request(), env)).status, 503);
  }
});

test("refuses untrusted raw MIME destinations without fetching them", async (t) => {
  for (const rawUrl of ["http://inbound-cdn.resend.com/raw", "https://10.0.0.2/private", "https://resend.com.evil.invalid/raw"]) {
    t.mock.restoreAll();
    const calls = mockUpstream(t, { rawUrl });
    assert.equal((await worker.fetch(request(), env)).status, 503);
    assert.equal(calls.length, 1);
  }
});

test("acknowledges mail over 25 MiB without forwarding it, with or without Content-Length", async (t) => {
  for (const options of [{ rawHeaders: { "content-length": String(25 * 1024 * 1024 + 1) } },
    { raw: new Uint8Array(25 * 1024 * 1024 + 1) }]) {
    t.mock.restoreAll();
    const calls = mockUpstream(t, options);
    assert.equal((await worker.fetch(request(), env)).status, 200);
    assert.equal(calls.length, 2);
  }
});

test("ignores foreign domains and events, validates IDs and limits webhook bytes", async (t) => {
  const calls = mockUpstream(t);
  assert.equal((await worker.fetch(request({ type: "email.sent" }), env)).status, 200);
  assert.equal((await worker.fetch(request({ ...event, data: { ...event.data, to: ["x@example.net"] } }), env)).status, 200);
  assert.equal((await worker.fetch(request({ ...event, data: { ...event.data, email_id: "../secrets" } }), env)).status, 400);
  assert.equal((await worker.fetch(request("null"), env)).status, 400);
  assert.equal((await worker.fetch(request("x".repeat(256 * 1024 + 1)), env)).status, 413);
  assert.equal(calls.length, 0);
});

test("returns health and rejects unrelated paths or methods", async () => {
  for (const [path, status] of [["/health", 200], ["/", 404], ["/api/v1/email/resend", 405]]) {
    assert.equal((await worker.fetch(new Request(`https://relay.example${path}`), env)).status, status);
  }
});
