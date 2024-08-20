global:
  addPrometheusAnnotations: true

authentik:
  secret_key: ${secret_key}
  error_reporting:
    enabled: false
  postgresql:
    password: ${postgres_password}

server:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  ingress:
    ingressClassName: traefik
    enabled: true
    hosts:
      - auth.${global_fqdn}
      - authentik.local

postgresql:
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
  enabled: true
  architecture: standalone
  auth:
    password: ${postgres_password}
  primary:
    persistence:
      enabled: true
      storageClass: longhorn
      accessModes:
          - ReadWriteOnce
      existingClaim: authentik-postgres-pvc
    extendedConfiguration: |
      max_connections = 500

redis:
  enabled: true
  master:
    persistence:
      storageClass: longhorn
      size: 2Gi

email:
  host: ${smtp_host}
  port: ${smtp_port}
  username: ${smtp_username}
  password: ${smtp_password}
  use_tls: ${smtp_use_tls}
  use_ssl: ${smtp_use_ssl}
  timeout: 30
  from: ${smtp_from}