ollama:
  extraEnv:
    - name: NVIDIA_DRIVER_CAPABILITIES
      value: all
    - name: NVIDIA_VISIBLE_DEVICES
      value: all
  runtimeClassName: nvidia
  ollama:
    gpu:
      enabled: true
      type: nvidia
      number: "1"
      nvidiaResource: "nvidia.com/gpu.shared"
  persistentVolume:
    enabled: true
    size: 50Gi
    storageClass: local-path

ingress:
  enabled: true
  host: ollama.${global_fqdn}

extraEnvVars:
  - name: ENABLE_IMAGE_GENERATION
    value: "False"
  - name: IMAGE_GENERATION_ENGINE
    value: automatic1111
  - name: AUTOMATIC1111_BASE_URL
    value: http://stable-diffusion.ai.svc.cluster.local:8080
  - name: WEBUI_URL
    value: https://ollama.${global_fqdn}
  - name: ENABLE_MESSAGE_RATING
    value: "True"
  - name: WEBUI_SECRET_KEY
    value: ${webui_secret_key}
  - name: PDF_EXTRACT_IMAGES
    value: "True"
  - name: VECTOR_DB
    value: chroma
  - name: CHROMA_HTTP_HOST
    value: chromadb.ai.svc.cluster.local
  - name: CHROMA_HTTP_HEADERS
    value: Authorization=Bearer ${chromadb_auth_token},User-Agent=OpenWebUI
  - name: DATABASE_URL
    value: postgresql://openwebui:${db_password}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/openwebui
  - name: WHISPER_MODEL_AUTO_UPDATE
    value: "True"
  - name: SEARCH_QUERY_GENERATION_PROMPT_TEMPLATE
    value: "Assess the need for a web search based on the current question and prior interactions, but lean towards suggesting a Google search query if uncertain. Generate a Google search query even when the answer might be straightforward, as additional information may enhance comprehension or provide updated data. If absolutely certain that no further information is required, return an empty string. Default to a search query if unsure or in doubt. ONLY respond with the search query. DO NOT respond with anything else. Today's date is {{CURRENT_DATE}}.\n\nCurrent Question:\n{{prompt:end:4000}}\n\nInteraction History:\n{{MESSAGES:END:6}}"
  - name: WEBUI_NAME
    value: Zefir's AI
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