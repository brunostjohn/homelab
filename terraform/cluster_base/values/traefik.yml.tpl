ingressRoute:
  dashboard:
    enabled: true

service:
  loadBalancerIP: ${cluster_ip}

deployment:
  replicas: 3

ports:
  traefik:
    port: 9000
    expose: true
  web:
    middlewares:
      - kube-system-all-middlewares@kubernetescrd
  websecure:
    middlewares:
      - kube-system-all-middlewares@kubernetescrd

experimental:
  plugins:
    enabled: true

additionalArguments:
  - "--experimental.plugins.bouncer.modulename=github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin"
  - "--experimental.plugins.bouncer.version=v1.3.3"

providers:
  kubernetesCRD:
    allowCrossNamespace: true

volumes:
  - name: crowdsec-bouncer-tls
    mountPath: /etc/traefik/crowdsec-certs/
    type: secret

metrics:
  prometheus:
    serviceMonitor:
      enabled: true
