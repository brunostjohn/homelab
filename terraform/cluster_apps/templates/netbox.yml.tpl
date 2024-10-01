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

remoteAuth:
  enabled: true
  backends: 
    - social_core.backends.open_id_connect.OpenIdConnectAuth
  autoCreateUser: true

extraConfig:
  - secret:
      secretName: oidc-client
  - values:
      SOCIAL_AUTH_PIPELINE:
        [
          "social_core.pipeline.social_auth.social_details",
          "social_core.pipeline.social_auth.social_uid",
          "social_core.pipeline.social_auth.social_user",
          "social_core.pipeline.user.get_username",
          "social_core.pipeline.social_auth.associate_by_email",
          "social_core.pipeline.user.create_user",
          "social_core.pipeline.social_auth.associate_user",
          "netbox.authentication.user_default_groups_handler",
          "social_core.pipeline.social_auth.load_extra_data",
          "social_core.pipeline.user.user_details",
          "netbox.sso_pipeline_roles.add_groups",
          "netbox.sso_pipeline_roles.remove_groups",
          "netbox.sso_pipeline_roles.set_roles",
        ]

extraVolumes:
  - name: sso-pipeline-roles
    configMap:
      name: sso-pipeline-roles
extraVolumeMounts:
  - name: sso-pipeline-roles
    mountPath: /opt/netbox/netbox/netbox/sso_pipeline_roles.py
    subPath: sso_pipeline_roles.py
    readOnly: true

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
  host: postgres-cluster-rw-pooler.databases.svc.cluster.local
  port: 5432
  database: netbox
  username: netbox
  password: ${db_password}

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
