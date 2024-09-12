server:
  ingress:
    enabled: true
    hosts:
      - host: vault.${global_fqdn}
        paths: ["/"]

dataStorage:
  size: 5Gi
  storageClass: longhorn

ui:
  enabled: true