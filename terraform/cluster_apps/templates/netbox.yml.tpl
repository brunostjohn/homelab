persistence:
  enabled: false

storageBackend: storages.backends.s3boto3.S3Boto3Storage
storageConfig:
  AWS_ACCESS_KEY_ID: ${aws_access_key_id}
  AWS_SECRET_ACCESS_KEY: ${aws_secret_access_key}
  AWS_STORAGE_BUCKET_NAME: netbox
  AWS_S3_ENDPOINT_URL: https://static.${global_fqdn}
  AWS_S3_REGION_NAME: unneeded

loginRequired: true

ingress:
  enabled: true
  hosts:
    - host: netbox.${global_fqdn}
      paths:
        - /


superuser:
  name: ${superuser_name}
  email: ${superuser_email}
  password: ${superuser_password}

readinessProbe:
  initialDelaySeconds: 240

startupProbe:
  initialDelaySeconds: 120

resources:
  requests:
    cpu: "0.5"
    memory: "1Gi"
    ephemeral-storage: "50Mi"
  limits:
    cpu: "1"
    memory: "2Gi"
    ephemeral-storage: "2Gi"

metrics:
  enabled: true
  serviceMonitor:
    enabled: true

postgresql:
  enabled: false

externalDatabase:
  enabled: true
  host: postgres-postgresql.databases.svc.cluster.local
  port: 5432
  database: netbox
  username: postgres
  password: postgres

redis:
  enabled: false

tasksRedis:
  host: redis-master.databases.svc.cluster.local
  port: 6379
  password: redis
  database: 4

cachingRedis:
  host: redis-master.databases.svc.cluster.local
  port: 6379
  password: redis
  database: 5
