# Household Rakazo

Stock upstream Rakazo at https://bots.zefirsroyal.cloud. No fork, image generation,
voice/video service, paid API fallback, or custom mobile build.

## Ownership and storage

`apps/clusterApps/templates/rakazo.yml` registers this directory with the existing
Argo CD parent. Infisical Development `/rakazo` supplies secrets. Only the migration
Job receives the database owner connection; API and worker use a restricted login.

API, worker, web and CLIProxyAPI run in Kubernetes. Computer supervisor and the
stock screen proxy run on Docker VM `10.0.194.215`, configured by
`hosts/claw/rakazo/compose.yml`. The VM's RAM remains 8 GiB at the user's request;
4 GiB per-computer cgroup ceilings do not reserve physical memory.

The 100 GiB RWX `rakazo-homes` PVC is provisioned on TrueNAS floof and uses a
Retain storage class. Docker mounts the same export; the export path in Compose
must follow the bound PV if the claim is ever replaced. The VM has a dedicated
20 GiB Docker/containerd disk, mounted persistently without changing its system disk.
The VM screen proxy reaches the authenticated API through NodePort 32100 on s3.

Homes and artifacts checkpoint to private, versioned MinIO bucket `rakazo-data`.
Noncurrent versions expire after seven days; current objects do not expire.
MinIO's existing server-wide multipart cleanup expires abandoned uploads after
24 hours. Each saved home remains subject to upstream's 5 GiB limit. Staging uses
bounded pod-local disk. A successful checkpoint is required to survive abrupt
computer loss; versioning is recovery protection, not immutable storage.

CLIProxyAPI uses its native PostgreSQL store and an ephemeral local mirror.
Neither computer containers nor the screen proxy receive S3 or database credentials.
The encryption key must be backed up separately from the database and object store.

## Verified during rollout, 10–11 November 2026

- All 252 upstream migrations completed on the existing PostgreSQL 15.13 cluster.
- API health/readiness, worker startup, public HTTPS and Bruno's Authentik login work.
- Authentik admission is restricted to the group containing Bruno and Klaudia.
- OpenAI/Codex and Claude OAuth accounts connected to the internal proxy.
- GPT-6.1 Sol passed text, vision and streamed tool-call checks; Claude Sonnet 5.5
  passed vision and streamed tool calls. Claude refreshed its OAuth token automatically.
  These two models are configured as deployment-wide choices.
- MinIO scoped credentials passed read/write/version recovery and cross-bucket denial.
- Personal and Family have separate native Honcho connections, workspace-scoped JWTs,
  and shared memory within each space. All three existing bots inherit that scope.
- Both memory workspaces passed save, semantic recall, subscription-backed reasoning,
  cross-space denial, pod-replacement persistence, replacement and forgetting checks.
  Family Chief also passed Rakazo's native save/recall/forget tools.
- Bruno's private iCloud connection uses a self-hosted authenticated MCP service in
  Personal only. Its 21 tools are connected; permanent deletion is disabled.
- The stock desktop app signs in through Authentik using TOTP. Its signed passkey
  domain does not include this self-hosted Authentik domain.
- Bruno confirmed delivery of the one-time Expo test notification on his physical
  iPhone using the stock Rakazo app. No custom app or Expo access token was needed.

## Memory

Honcho v3.6.1 runs an API and one deriver worker on the existing PostgreSQL cluster,
with a separate database and restricted runtime role. Redis and telemetry are disabled.
The migration Job alone receives owner credentials. Its guarded correction sets the
two initially empty embedding columns to vector(1024); it refuses to reinterpret
nonempty columns of another dimension.

CPU Text Embeddings Inference uses BGE-M3 revision
`5617a9f61b028005a4858fdac845db406aefb181`, baked into the pinned image. CPU warmup
exceeded 8 GiB, so the service requests/limits 16 GiB and allows ten minutes to start;
measured steady memory was approximately 2.7 GiB. Inputs are limited to 8,192 tokens
with automatic truncation disabled. No new PVC or paid embedding endpoint is used.
All enabled Honcho reasoning routes use the internal subscription proxy and low
reasoning effort. Network policies prevent external paid-provider calls.

Native fact saving and recall supplement MEMORY.md; whole conversations are not
ingested. Honcho facts and vectors are sensitive plaintext database content.
Workspace JWTs are encrypted in Rakazo's stored connection credentials; the signing
key is in Infisical. Operator bootstrap credentials are not given to Rakazo.

`honcho-smoke.py seed`, followed by pod replacement and `honcho-smoke.py verify`,
exercises synthetic facts and removes them. It requires private workspace-token files
through `HONCHO_TOKEN_DIR` and a local operator forward through `HONCHO_URL`.
Prometheus successfully scrapes API, worker and embeddings; rules cover unavailable
memory, queue age and stale queue metrics. The HTTP-mode TEI image exposes `/metrics`
on its HTTP port 8080. Prometheus is running on s3 after its Pi became unreachable.

## Family Mealie

`mealie-family.yml` runs the stock `mdlopresti/mealie-mcp` image pinned by digest,
with its native FastMCP HTTP entrypoint and the same authenticated proxy pattern as
private iCloud. The server binds only to pod loopback; its gateway accepts a dedicated
bearer token, and network policy permits only Rakazo API/worker ingress plus Mealie
and DNS egress. Both credentials are in Infisical `/rakazo`; no PVC is added.

The native connection is named **Mealie Family** and available only in Family.
Discovery exposes 116 tools. Authentication rejection, recipe/meal-plan/shopping-list
reads, and creation/read/item-addition/deletion of a uniquely named temporary list
passed; the temporary data was removed. The Mealie API token is named `Rakazo Family`
and acts as Bruno in his existing Mealie household.

Mealie v3.30.0 was crash-looping on its `authmethod` enum migration. Correcting only
that enum's owner to the existing `mealie` login let the installed migrations finish.
Existing recipes were preserved. No Mealie source change was made.

Infisical's session-pooled PostgreSQL path also timed out during integration setup.
A direct-connection transaction check passed in 77 ms while the pooled check timed
out. Its existing bootstrap Secret `infisical/infisical-secrets` now uses
`postgres-cluster-rw.databases.svc.cluster.local` in `DB_CONNECTION_URI`, with the
same credentials/database. Both replicas recovered and secret saves/sync resumed.
This bootstrap Secret is not operator-managed; do not restore the exhausted pooler
hostname from legacy Terraform.

Both PostgreSQL templates contain pre-existing legacy objects. In the new Rakazo
and proxy databases only, the inherited `public.system` table was moved into
`inherited_template_quarantine` and access to inherited schemas revoked from PUBLIC.
No inherited data was deleted. An unused `rakazo_app` template0 probe database also
remains quarantined. Active database names are `rakazo` and `rakazo_proxy`.

## Household infrastructure MCPs

Kubernetes and Home Assistant run stock, digest-pinned MCP servers behind the same
internal bearer-authenticated gateway pattern as Mealie. Their native Rakazo
connections explicitly select Personal and Family, rather than future spaces.
Both passed missing/wrong/case-altered token rejection and authenticated discovery.
Kubernetes exposes 23 tools and passed namespace listing plus create/read/update/delete
of a uniquely named temporary ConfigMap; the test object was removed. Home Assistant
exposes 77 tools and passed its system-health call against the installed 2026.11.1.
Its API credential is the user-provided `/rakazo/HASSIO_TOKEN`.

The Kubernetes MCP has a dedicated cluster-admin service account, as requested for
homelab administration. Its projected token is mounted only in the MCP container;
the authentication sidecar has none. It reaches the Kubernetes API and HTTPS chart
registries. Home Assistant egress is limited to its existing service and DNS.
Neither deployment adds a PVC. Home Assistant MCP settings are fixed in environment
variables and its settings UI is disabled; pod-local caches/settings are disposable.

Kubernetes MCP uses a rolling update with zero unavailable replicas. A proxy-image
update with the former Recreate strategy interrupted Chief at 23:20 UTC with a
connection-refused error. Native read calls using the stored credential subsequently
passed in both Personal and Family. A controlled replacement passed 35 consecutive
native Rakazo calls with no failures. The internal token requires no manual login.

UniFi's native Composio connection now uses the replacement `Rakazo household` key;
the old account connection and both superseded keys were removed. The live key is
also stored as `/rakazo/UNIFI_API_KEY`. Its current expiry is 10 December 2026; renew
it before then and update Infisical, both Composio connected accounts and the encrypted
credential on the custom UniFi Network integration. Site Manager is connected separately
in Personal and Family. Its catalog covers inventory and metrics only.

**UniFi Network** adds all 73 operations from the official Network 10.6.109 OpenAPI
schema through Rakazo's native API adapter. Native application-info and site-list calls
passed in both spaces. Its concrete Cloud Connector URL uses `/network/integration`,
with the selected console ID substituted before import. The importer does not resolve
server variables, and one overlong description uses its official summary to meet the
2,000-character limit. This is connector configuration, not an application modification.

Import the public schema separately from the API credential: stock OpenAPI setup sends
the credential to the schema URL too. The prepared configuration was validated through
`prepareApiInstall` and saved with Rakazo's native encrypted secret format. The key is
sent only to `api.ui.com`, in `X-API-Key`; no key is stored in the schema or model inputs.
Custom infrastructure integrations explicitly select Personal and Family. Stock Rakazo
also ties integrations to the account that installs them; another member's own bots
need that member's connection rather than inheriting Bruno's private credentials.

These connections carry broad administrative access. Stock Auto approval is an AI review,
not a guaranteed human gate. Its reviewer prompt is not operator-configurable, and shell,
file writes and computer actions can bypass the MCP review path. MCP server instructions
and NAS `confirm` parameters are not enforcement boundaries.

`ssh-mcp.yml` uses stock ssh-mcp 2.25.0 through Supergateway 4.2.2, with strict pinned
host keys and a separate `restrict` SSH key on six reachable Kubernetes nodes and
Docker VM 10.0.194.215. Its seven profiles use the existing `brunostjohn` account;
existing sudo access on the Kubernetes nodes is unchanged. Docker administration
uses that account's existing Docker group. Proxmox SSH and the offline Pi are not
configured. Config and key copies have private permissions on a memory emptyDir;
no new PVC or account is created. Stateful sessions and local audit files are lost
on pod replacement. Rakazo Auto reviews MCP writes; SSH's own elicitation cannot
be used by the current Rakazo client, so SSH uses `auto`. This is broad admin access,
not a guaranteed human gate for every destructive command.

`truenas-floof.yml` and `truenas-jabberwock.yml` use stock truenas-mcp 1.0.0 with the
existing TrueNAS 25.04 REST API. Each has its own `Rakazo Household` admin key,
expiring 10 November 2027, in Infisical `/rakazo`. A loopback proxy verifies each
NAS's pinned public TLS certificate with its actual `localhost` identity; TLS
verification is not disabled. Update the mounted public certificate when it rotates.
Egress reaches only that NAS on 443 and cluster DNS. The single hierarchical tool
covers storage, sharing, accounts and other NAS APIs; its `confirm` argument is not
a human approval boundary. Both NAS connections and SSH are for Personal and Family.
Native Rakazo SSH execution and both NAS pool-list calls passed in each space. Private
temporary SSH/API-key transfer files were removed after verification.

## Email and monitoring

The Resend receiving bridge is deployed as the `rakazo-email` Cloudflare Worker.
Source, seven passing fixture tests and operational details are under
`projects/rakazo-email/`. Resend sending and receiving are verified for the bot subdomain;
root-domain iCloud mail is unchanged. Signature rejection, ignored-event handling and
live health checks passed. The real sender/attachment/reply test remains pending at the
user's request. `career-partner@bots.zefirsroyal.cloud` is the currently claimed address.
Stock sender validation uses Bruno's login identity `brunost.john@icloud.com`; connecting
the `brunoturek@icloud.com` mailbox does not change that identity.

`operations-monitoring.yml` adds bucket/version metrics, capacity and growth prediction,
backup freshness, WAL failure, service health, embedding errors and UniFi key-expiry
alerts to the existing Prometheus stack. Live targets and rule evaluation passed.

`log-metrics.yml` runs stock Alloy with namespace-scoped pod/log read permissions.
It counts persistence and subscription errors from API, worker and proxy logs, retains
no raw logs, sends nothing externally and adds no PVC. Labels contain only the app and
collector metadata. The counters are best-effort: pod replacement can replay recent
logs, and future upstream log changes may require updating the expressions. Validation
used five synthetic lines: an ordinary line, `previous home revision removal failed`,
`computer.checkpoint_skipped`, `invalid_grant`, and `429 /v1/chat/completions`.
The resulting observed/persistence/subscription counters were exactly 5/2/2.

## Backup recovery

The retained 6 November n5 backup was restored on isolated scratch storage, replayed
its required WAL and successfully queried all 63 connectable databases. This was
restore/access verification, not an application-level integrity audit. Obsolete
completed n5 backups were pruned and roughly 500 GiB reclaimed. A fresh backup,
`minio-recovery-20261110`, completed at 20:24 UTC. Its archive `20261110T193941`
also restored on isolated scratch storage, replayed all 13 required WAL segments,
promoted and queried all 66 databases at 23:41 UTC. Retired-archive cleanup is in progress.
The s4 VM subsequently stopped; after confirming it was powered off, MinIO's
terminating pod was replaced on s3 using the same cached image digest. Both MinIO
pods are running and WAL archiving resumed at 22:07 UTC. The s4 VM remains stopped.
The temporary MinIO network restriction was removed and the NAS reservation restored.
MinIO's stable root credentials and rotated OIDC secret are now managed in Infisical.
A fresh Authentik login passed after rotation. Storage has several TiB free again.

The retained 2024 MinIO version rejects the current AWS SDK's multi-object deletion
without Content-MD5. Rakazo checkpoints succeed, but removal of older home revisions
fails and needs a storage compatibility fix. Newer MinIO releases remove the bundled
OIDC administration console, so upgrading requires accounting for that behavior rather
than changing the image blindly. No Rakazo source patch or runtime monkeypatch is used.

## Still being completed

- Docker browser/terminal/takeover and saved-home restoration checks.
- Proxy OAuth refresh and complete pod-replacement persistence checks.
- Klaudia's own space/integration access and the explicitly deferred real email test.
- Live error-counter scraping after its GitOps rollout.
- Final retention cleanup, nightly backup completion and MinIO checksum compatibility.
- Separate recoverable encryption-key copy and remaining failure/persistence checks.
