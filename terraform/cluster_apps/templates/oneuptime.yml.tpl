global:
  storageClass: longhorn

httpProtocol: https

host: uptimes.${global_fqdn}

postgresql:
  enabled: false

nginx:
  service:
    type: ClusterIP

oneuptimeIngress:
  enabled: true
  className: traefik
  hosts:
    - uptimes.${global_fqdn}
    - status.${global_fqdn}

externalPostgres:
  host: postgres-cluster-rw-pooler.databases.svc.cluster.local
  port: 5432
  username: oneuptime
  password: ${db_password}
  database: oneuptime
  ssl:
    enabled: false

redis:
  enabled: false

externalRedis:
  host: redis.databases.svc.cluster.local
  port: 6379
  existingSecret:
    name: oneuptime-redis
    passwordKey: password
  database: 12
  tls:
    enabled: false
