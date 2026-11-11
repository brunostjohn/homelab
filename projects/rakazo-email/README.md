# Rakazo inbound email

This dependency-free Cloudflare Worker verifies Resend's Svix signature, retrieves
original MIME and forwards it unchanged to stock Rakazo. Rakazo owns sender DKIM
checks, mailbox permissions, attachments and per-bot deduplication. It requires no
Rakazo fork, database or Worker KV.

Production Worker: `rakazo-email`, account `57f528bacfe332eba535f374ab15e384`.
Endpoint: `https://rakazo-email.brunost-john.workers.dev/api/v1/email/resend`.
Health: `https://rakazo-email.brunost-john.workers.dev/health`.
Resend webhook `04701fc5-e600-4786-827d-456b68d1a3f9` subscribes to `email.received`.
Receiving and sending are enabled for `bots.zefirsroyal.cloud`; root-domain iCloud
mail records remain unchanged.

Cloudflare encrypted bindings (also stored in Infisical `/rakazo`):

- `RESEND_API_KEY`: full access, to retrieve original received messages.
- `RESEND_WEBHOOK_SECRET`: the webhook's `whsec_` signing key.
- `INBOUND_EMAIL_SECRET`: must match Rakazo's authenticated inbound endpoint.

Deploy `worker.mjs` as the Worker's ES module using Cloudflare's dashboard. Current
compatibility date is 2026-11-10. The existing infrastructure API token cannot update
Workers; dashboard deployment is currently manual. Do not recreate the Resend webhook
unless you also replace its signing secret. Never commit the bindings.

Only recipients under `@bots.zefirsroyal.cloud` are forwarded. MIME is limited to
Rakazo's native 25 MiB. Oversized messages are acknowledged and skipped; upstream
and delivery failures return 503 so Resend retries. Raw download URLs must be HTTPS
under `.resend.com` or `.cloudfront.net`; no credentials accompany those downloads.
The 48-recipient cap fits the free Worker's 50-subrequest limit.

Run `node --test projects/rakazo-email/worker.test.mjs` from the repository root.
Tests cover signatures, replay window, original MIME, attachment preservation,
recipient handling, retry behavior, download-host restrictions and size limits.
Live checks verified health, method rejection, forged-signature rejection and a
properly signed ignored event. A genuine received-email/attachment/reply test is
pending; no email was sent by the deployment process.

Bot addresses are claimed through Rakazo's native settings. `career-partner` is
already claimed. Owner-triggered work requires the exact verified Rakazo login
email; connecting a different iCloud mailbox does not change that identity.
