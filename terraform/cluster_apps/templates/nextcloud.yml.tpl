image:
  repository: nextcloud
  flavor: fpm 
  pullPolicy: IfNotPresent

ingress:
  enabled: true

phpClientHttpsFix:
  enabled: true
  protocol: https

persistence:
  enabled: true
  storageClass: longhorn
  nextcloudData:
    enabled: false

resources:
  requests:
    cpu: "1"
    memory: "1Gi"
  limits:
    cpu: "2"
    memory: "2Gi"

nginx:
  image:
    repository: nginxinc/nginx-unprivileged
  enabled: true
  config:
    default: true
  containerPort: 80
  extraEnv: 
    - name: TRUSTED_PROXIES
      value: traefik.kube-system

startupProbe:
  enabled: false
livenessProbe:
  enabled: false
readinessProbe:
  enabled: false

nextcloud:
  securityContext:
    runAsUser: 33
    runAsGroup: 33
  podSecurityContext:
    runAsUser: 33
    runAsGroup: 33
    fsGroup: 33
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
      ssl: false
      port: 9000
      accessKey: ${s3_access_key}
      secretKey: ${s3_secret_key}
      host: ${s3_host}
      bucket: nextcloud
      usePathStyle: true
  defaultConfigs:
    redis.config.php: false
  phpConfigs:
    zz-opcache.conf: |-
      php_admin_value[memory_limit] = -1
      php_admin_value[opcache.interned_strings_buffer] = 64
      php_admin_value[opcache.memory_consumption] = 1G
      php_admin_value[opcache.max_accelerated_files] = 30000
      php_admin_value[opcache.validate_timestamps] = 0
      php_admin_value[opcache.revalidate_freq] = 60
      php_admin_value[opcache.jit] = 1255
      php_admin_value[opcache.jit_buffer_size] = 128M
    zz-pm.ini: |-
      pm.max_children=57
      pm.start_servers=14
      pm.min_spare_servers=14
      pm.max_spare_servers=42
  configs:
    replicas.config.php: |-
      <?php
        $CONFIG = array(
          'dbreplica' => [
            [
              'user' => 'nextcloud',
              'password' => '${db_password}',
              'host' => 'postgres-cluster-ro-pooler.databases.svc.cluster.local',
              'dbname' => 'nextcloud'
            ],
          ],
        );
    oidc.config.php: |-
      <?php
        $CONFIG = array(
          'user_oidc' => array(
            'allow_multiple_user_backends' => false,
          )
        );
    datadir.config.php: |-
      <?php
        $CONFIG = array (
          'check_data_directory_permissions' => false,
        );
    redis.config.php: |-
      <?php
        $CONFIG = array(
          'memcache.locking' => '\OC\Memcache\Redis',
          'memcache.distributed' => '\OC\Memcache\Redis',
          'memcache.local' => '\OC\Memcache\APCu',
          'redis' => array(
            'host' => 'redis.databases.svc.cluster.local',
            'port' => 6379,
            'password' => 'redis',
            'dbindex' => 1,
          ),
        );
    previews.config.php: |-
      <?php
        $CONFIG = array(
          'preview_format' => 'webp',
          'enabledPreviewProviders' => [
            'OC\Preview\MP3',
            'OC\Preview\TXT',
            'OC\Preview\MarkDown',
            'OC\Preview\OpenDocument',
            'OC\Preview\Krita',
            'OC\Preview\Imaginary',
          ],
          'preview_imaginary_url' => 'http://imaginary.nextcloud.svc.cluster.local:9000',
        );

internalDatabase:
  enabled: false

externalDatabase:
  enabled: true
  type: postgresql
  host: postgres-cluster-rw-pooler.databases.svc.cluster.local
  user: nextcloud
  password: ${db_password}
  database: nextcloud

cronjob:
  enabled: true
  securityContext:
    allowPrivilegeEscalation: false
    runAsUser: 0

hpa:
  enabled: false

metrics:
  enabled: true
  serviceMonitor:
    enabled: true