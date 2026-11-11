# MinIO infrastructure

The existing `minio-secrets` Argo CD Application owns these resources. Infisical
supplies stable root credentials and the rotated OIDC client secret.

The `minio-auth-console` Deployment preserves the currently installed, unmodified
2024 embedded console and its Authentik login. `MINIO_SERVER_URL` directs all its
console S3/STS/admin requests to the real `minio` Service. Its unused local S3
listener binds only loopback; its scratch data is disposable `emptyDir`. The
Deployment exposes only the console port to Traefik and mounts no production data.
Replacing this pod ends its console sessions; sign in again through Authentik.

The newer upstream storage releases removed console OIDC support. Standalone
Console v1.7.6 also ignores its legacy OIDC environment settings in its CLI, so
that build experiment was removed. No application or MinIO source is patched.
The retained console remains an older, unmaintained UI; upgrading the storage
server does not make that UI current.

Before changing the storage server, isolated tests passed encrypted-home-compatible
versioned object recovery, multipart integrity, SDK CRC32 multi-delete, and an old
two-drive cluster upgrade retaining versions and scoped IAM credentials. The
preserved embedded console also passed login and bucket create/read/delete against
the newer server, verified independently through the S3 API.

Keep the MinIO server image pinned by digest. Pause obsolete-backup cleanup and
avoid active full backups during a two-pod restart: this two-drive deployment needs
both drives for write quorum. WAL remains on PostgreSQL while archiving retries.
Never delete files from the MinIO backing directories to make space.
