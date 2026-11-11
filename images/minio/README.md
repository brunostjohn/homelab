# Stock MinIO source image

Builds the unmodified upstream `RELEASE.2025-10-15T17-29-55Z` through its documented
`go install` path. MinIO no longer publishes community binaries or container images
for this release. The entrypoint is copied unchanged from that upstream tag.
The existing Helm chart expects its `/usr/bin/docker-entrypoint.sh` location.

This image is for isolated compatibility testing first. Building/publishing it does
not update the production MinIO Application. The release will be tested against the current SDK's
checksum behavior and removes the old console's administration/OIDC behavior;
preserving that behavior needs a separately validated console arrangement.

Before a production update, test multipart upload/completion, scoped credentials,
multi-object deletion, bucket versioning and OIDC/STS against isolated empty storage,
then pin the resulting image digest in GitOps. Keep the existing restored PostgreSQL
recovery set and coordinate with in-progress backups and archive cleanup.

Source and license: https://github.com/minio/minio/tree/RELEASE.2025-10-15T17-29-55Z
