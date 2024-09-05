resources:
  requests:
    memory: 2Gi

replicas: 2

metrics:
  serviceMonitor:
    enabled: true
    includeNode: true

environment:
  MINIO_DOMAIN: static.${global_fqdn}

persistence:
  enabled: true
  storageClass: ${sc_name}
  size: ${size}

securityContext:
  enabled: false

oidc:
  enabled: true
  configUrl: "${oidc_config_url}"
  clientId: "${oidc_client_id}"
  clientSecret: "${oidc_client_secret}"
  claimName: "policy"
  scopes: "openid profile email minio"
  redirectUri: "https://minio.${global_fqdn}/oauth_callback"
  displayName: "Zefir's Cloud"