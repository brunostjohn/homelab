chromadb:
  dataVolumeStorageClass: longhorn
  dataVolumeSize: "4Gi"
  auth:
    enabled: true
    type: "token"
    token:
      headerType: "Authorization"
      value: ${auth_token}