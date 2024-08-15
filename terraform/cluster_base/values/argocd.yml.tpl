global:
  image:
    tag: v2.11.7
  addPrometheusAnnotations: true

configs:
  url: http://argocd.local
  cm:
    dex.config: |
      connectors:
        - type: oidc
          id: oidc
          name: OIDC
          config:
            issuer: https://auth.${global_fqdn}/application/o/argocd/
            clientID: ${oidc_client_id}
            clientSecret: ${oidc_client_secret}

controller:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

repoServer:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

server:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  extraArgs:
    - --insecure

dex:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

redis:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

redis-ha:
  haproxy:
    metrics:
      enabled: true
      serviceMonitor:
        enabled: true

applicationSet:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

notifications:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
