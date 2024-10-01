global:
  addPrometheusAnnotations: true
  env:
    - name: AUTHENTIK_REDIS__HOST
      value: redis.databases.svc.cluster.local
    - name: AUTHENTIK_REDIS__PASSWORD
      value: redis
    - name: AUTHENTIK_REDIS__PORT
      value: "6379"
    - name: AUTHENTIK_REDIS__DB
      value: "6"

authentik:
  secret_key: ${secret_key}
  error_reporting:
    enabled: false
  postgresql:
    name: authentik
    user: authentik
    host: postgres-cluster-rw-pooler.databases.svc.cluster.local
    password: ${postgres_password}
  redis:
    host: redis.databases.svc.cluster.local
    password: redis

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
  enabled: false

redis:
  enabled: false

email:
  host: ${smtp_host}
  port: ${smtp_port}
  username: ${smtp_username}
  password: ${smtp_password}
  use_tls: ${smtp_use_tls}
  use_ssl: ${smtp_use_ssl}
  timeout: 30
  from: ${smtp_from}