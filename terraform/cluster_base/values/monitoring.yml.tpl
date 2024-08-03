namespaceOverride: ${namespace}

alertmanager:
  storage:
    volumeClaimTemplate:
      storageClassName: longhorn
      resources:
        requests:
          storage: 512Mi

grafana:
  ingress:
    enabled: true
    ingressClassName: traefik
    hosts:
      - grafana.${global_fqdn}
  persistance:
    enabled: true
    storageClassName: longhorn
    size: 1Gi