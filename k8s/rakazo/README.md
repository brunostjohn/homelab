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

## Verified during rollout, 10 November 2026

- All 252 upstream migrations completed on the existing PostgreSQL 15.13 cluster.
- API health/readiness, worker startup, public HTTPS and Bruno's Authentik login work.
- Authentik admission is restricted to the group containing Bruno and Klaudia.
- OpenAI/Codex and Claude OAuth accounts connected to the internal proxy.
- GPT-6.1 Sol passed text, vision and streamed tool-call checks; Claude Sonnet 5.5
  passed vision. These two models are configured as deployment-wide choices.
- MinIO scoped credentials passed read/write/version recovery and cross-bucket denial.

Both PostgreSQL templates contain pre-existing legacy objects. In the new Rakazo
and proxy databases only, the inherited `public.system` table was moved into
`inherited_template_quarantine` and access to inherited schemas revoked from PUBLIC.
No inherited data was deleted. An unused `rakazo_app` template0 probe database also
remains quarantined. Active database names are `rakazo` and `rakazo_proxy`.

## Backup recovery

The retained 6 November n5 backup was restored on isolated scratch storage, replayed
its required WAL and successfully queried all 63 connectable databases. This was
restore/access verification, not an application-level integrity audit. Obsolete
completed n5 backups were pruned and roughly 500 GiB reclaimed. WAL archiving is
running again; a fresh backup and retired-archive cleanup are still in progress.
The temporary MinIO network restriction was removed and the NAS reservation restored.

## Still being completed

- Docker browser/terminal/takeover and saved-home restoration checks.
- Proxy OAuth refresh and complete pod-replacement persistence checks.
- Honcho 3.6.0 with per-space credentials and local BGE-M3 embeddings.
- Personal/Family spaces, inbound Resend bridge, Composio and stock iPhone push tests.
- Family administration credentials and verified deletion approval policy.
- Existing Prometheus integration, storage/backup alerts and application health checks.
- Fresh backup verification, final retention cleanup, MinIO OIDC rotation and durable image source.
- Separate recoverable encryption-key copy and remaining failure/persistence checks.
