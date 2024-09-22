ollama:
  persistentVolume:
    enabled: true
    size: 50Gi
    storageClass: floof-iscsi-csi

ingress:
  enabled: true
  host: ollama.${global_fqdn}

extraEnvVars:
  - name: ENABLE_OAUTH_SIGNUP
    value: "True"
  - name: OAUTH_MERGE_ACCOUNTS_BY_EMAIL
    value: "True"
  - name: OAUTH_USERNAME_CLAIM
    value: "preferred_username"
  - name: OAUTH_CLIENT_ID
    value: ${client_id}
  - name: OAUTH_CLIENT_SECRET
    value: ${client_secret}
  - name: OAUTH_PROVIDER_NAME
    value: Zefir's Cloud
  - name: OPENID_PROVIDER_URL
    value: ${openid_provider_url}