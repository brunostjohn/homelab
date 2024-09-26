coder:
  env:
    - name: CODER_PG_CONNECTION_URL
      value: postgresql://coder:${db_password}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/coder
    - name: CODER_ACCESS_URL
      value: https://envs.${global_fqdn}
    - name: CODER_OIDC_ISSUER_URL
      value: https://auth.${global_fqdn}/application/o/coder/
    - name: CODER_OIDC_CLIENT_ID
      value: ${oidc_client_id}
    - name: CODER_OIDC_CLIENT_SECRET
      value: ${oidc_client_secret}
    - name: CODER_DISABLE_PASSWORD_AUTH
      value: "true"
    - name: CODER_OIDC_SIGN_IN_TEXT
      value: "Sign in with Zefir's Cloud"
    - name: CODER_OIDC_ICON_URL
      value: "https://homepage-assets.static.${global_fqdn}/images/server-icon.png"
    - name: CODER_TELEMETRY
      value: "false"
    - name: CODER_WILDCARD_ACCESS_URL
      value: "*.envs.${global_fqdn}"

  service:
    type: ClusterIP

  ingress:
    enable: true
    host: envs.${global_fqdn}
    wildcardHost: "*.envs.${global_fqdn}"
    tls:
      enable: true
