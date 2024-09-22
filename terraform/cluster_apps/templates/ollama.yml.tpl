ollama:
  gpu:
    enabled: true
    type: nvidia
    number: 5
    nvidiaResource: "nvidia.com/gpu.shared"
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
  - name: ENABLE_OPENAI_API
    value: "False"
  - name: ENABLE_IMAGE_GENERATION
    value: "False"
  - name: ENABLE_RAG_WEB_SEARCH
    value: "True"
  - name: ENABLE_SEARCH_QUERY
    value: "True"
  - name: RAG_WEB_SEARCH_ENGINE
    value: google_pse
  - name: GOOGLE_PSE_API_KEY
    value: ${google_pse_api_key}
  - name: GOOGLE_PSE_ENGINE_ID
    value: ${google_pse_engine_id}
  - name: AUDIO_TTS_ENGINE
    value: openai
  - name: AUDIO_TTS_API_KEY
    value: sk-111111111
  - name: AUDIO_TTS_OPENAI_API_BASE_URL
    value: http://openedai-tts.ai.svc.cluster.local:8000/v1
    

persistence:
  storageClass: floof-iscsi-csi