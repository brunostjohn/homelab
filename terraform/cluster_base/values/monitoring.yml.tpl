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
  grafana.ini:
    server:
      root_url: https://grafana.zefirsroyal.cloud

prometheus:
  prometheusSpec:
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: longhorn
          resources:
            requests:
              storage: 4Gi