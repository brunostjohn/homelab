server:
  env:
    EMAIL_HOST: ${smtp_host}
    EMAIL_PORT: ${smtp_port}
    EMAIL_USE_TLS: 'True'
    EMAIL_HOST_USER: ${smtp_user}
    EMAIL_HOST_PASSWORD: ${smtp_password}
    DEFAULT_FROM_EMAIL: noreply@${global_fqdn}
    # ADMIN_IP_WHITELIST:
    SITE_IS_PUBLIC: "True"
    ACCOUNT_ALLOW_SIGN_UP: "False"
    SOCIAL_LOGIN: "True"
    OCTOPRINT_TUNNEL_PORT_RANGE: "0-0"
    REDIS_URL: redis://:redis@redis-master.databases.svc.cluster.local:6379/3
    DATABASE_URL: postgresql://postgres:postgres@postgres-postgresql.databases.svc.cluster.local:5432/obico
    # TELEGRAM_BOT_TOKEN:
    # TWILIO_ACCOUNT_SID:
    # TWILIO_AUTH_TOKEN:
    # TWILIO_FROM_NUMBER:
    # SENTRY_DSN:
    # PUSHOVER_APP_TOKEN:
    # SLACK_CLIENT_ID:
    # SLACK_CLIENT_SECRET:
  persistence:
    data:
      enabled: true
      size: 10Gi
      storageClass: nfs-jabberwock-subpath
      accessMode: ReadWriteOnce
    media:
      enabled: true
      size: 10Gi
      storageClass: nfs-jabberwock-subpath
      accessMode: ReadWriteOnce
  ingress:
    main:
      enabled: true
      hosts:
        - host: obico.${global_fqdn}
          paths:
            - path: /

redis:
  enabled: false