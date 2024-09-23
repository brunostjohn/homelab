env:
  REDIS_HOSTNAME: redis-master.databases.svc.cluster.local
  REDIS_PORT: "6379"
  REDIS_PASSWORD: redis
  REDIS_DBINDEX: "9"
  DB_HOSTNAME: postgres-cluster-rw.databases.svc.cluster.local
  DB_USERNAME: immich
  DB_DATABASE_NAME: immich
  DB_PASSWORD: ${db_password}

image:
  tag: v1.114.0

immich:
  metrics:
    enabled: true
  persistence:
    library:
      existingClaim: immich-library

postgresql:
  enabled: false

redis:
  enabled: false

server:
  enabled: true

machine-learning:
  enabled: true
  persistence:
    cache:
      enabled: true
      size: 10Gi
      type: pvc
      storageClass: floof-nfs-csi
      accessMode: ReadWriteMany
