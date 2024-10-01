ingress:
  appHost: plane.${global_fqdn}
  ingressClass: traefik

redis:
  local_setup: false

postgres:
  local_setup: false

minio:
  local_setup: false

web:
  image: ghcr.io/torbenraab/plane/plane-frontend

space:
  image: ghcr.io/torbenraab/plane/plane-space

admin:
  image: ghcr.io/torbenraab/plane/plane-admin

api:
  image: ghcr.io/torbenraab/plane/plane-backend

worker:
  image: ghcr.io/torbenraab/plane/plane-backend

beatworker:
  image: ghcr.io/torbenraab/plane/plane-backend

env:
  pgdb_remote_url: postgresql://plane:${db_password}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/plane

  remote_redis_url: redis://:redis@redis-master.databases.svc.cluster.local:6379/11

  docstore_bucket: plane-uploads
  doc_upload_size_limit: "5242880"

  aws_access_key: ${aws_access_key_id}
  aws_secret_access_key: ${aws_secret_access_key}
  aws_region: irrelevant
  aws_s3_endpoint_url: https://plane-uploads.static.${global_fqdn}/

  secret_key: ${secret_key}
