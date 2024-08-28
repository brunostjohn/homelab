ingress:
  enabled: true

persistence:
  enabled: true
  storageClass: nfs-jabberwock-subpath
  nextcloudData:
    enabled: true
    storageClass: nfs-jabberwock-subpath

startupProbe:
  enabled: true
livenessProbe:
  enabled: true
readinessProbe:
  enabled: true

nextcloud:
  host: nextcloud.${global_fqdn}
  mail:
    enabled: true
    fromAddress: noreply
    domain: ${global_fqdn}
    smtp:
      host: ${smtp_host}
      secure: ssl
      port: ${smtp_port}
      name: ${smtp_username}
      password: ${smtp_password}
  objectStore:
    s3:
      enabled: true
      accessKey: ${s3_access_key}
      secretKey: ${s3_secret_key}
      host: ${s3_host}
      bucket: nextcloud-data
      usePathStyle: true
  defaultConfigs:
    redis.config.php: false
  configs:
    redis.config.php: |-
      <?php
        $CONFIG = array(
          'memcache.locking' => '\OC\Memcache\Redis',
          'memcache.distributed' => '\OC\Memcache\Redis',
          'redis' => array(
            'host' => 'redis-master.databases.svc.cluster.local',
            'port' => 6379,
            'password' => 'redis',
            'dbindex' => 1,
          ),
        );

internalDatabase:
  enabled: false

externalDatabase:
  enabled: true
  type: postgresql
  host: postgres-postgresql.databases.svc.cluster.local
  user: postgres
  password: postgres
  database: nextcloud

cronjob:
  enabled: true

hpa:
  enabled: true
  maxPods: 3

metrics:
  enabled: true
  serviceMonitor:
    enabled: true