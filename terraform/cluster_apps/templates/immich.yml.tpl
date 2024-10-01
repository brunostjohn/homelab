env:
  REDIS_HOSTNAME: redis-master.databases.svc.cluster.local
  REDIS_PORT: "6379"
  REDIS_PASSWORD: redis
  REDIS_DBINDEX: "9"
  DB_HOSTNAME: postgres-cluster-rw-pooler.databases.svc.cluster.local
  DB_USERNAME: immich
  DB_DATABASE_NAME: immich
  DB_PASSWORD: ${db_password}
  # NVIDIA_VISIBLE_DEVICES: all
  # NVIDIA_DRIVER_CAPABILITIES: "compute,video,utility"

image:
  tag: v1.115.0

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
  # resources:
  #   requests:
  #     nvidia.com/gpu.shared: "1"
  #   limits:
  #     nvidia.com/gpu.shared: "1"
  # runtimeClassName: nvidia
  resources:
    requests:
      amd.com/gpu: "0"
    limits:
      amd.com/gpu: "0"
  enabled: true

machine-learning:
  # image:
  #   tag: v1.115.0-cuda
  # resources:
  #   requests:
  #     nvidia.com/gpu.shared: "1"
  #   limits:
  #     nvidia.com/gpu.shared: "1"
  # runtimeClassName: nvidia
  enabled: true
  persistence:
    cache:
      enabled: true
      size: 10Gi
      type: pvc
      storageClass: floof-nfs-csi
      accessMode: ReadWriteMany
