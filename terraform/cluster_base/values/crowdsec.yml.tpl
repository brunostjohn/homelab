container_runtime: containerd

tls:
  enabled: true
  bouncer:
    reflector:
      namespaces: ["kube-system"]

metrics:
  enabled: true
  serviceMonitor:
    enabled: true

agent:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  acquisition:
    - namespace: traefik
      podName: traefik-*
      program: traefik
  env:
    - name: COLLECTIONS
      value: "crowdsecurity/traefik"
    - name: PARSERS
      value: "crowdsecurity/cri-logs"

lapi:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  dashboard:
    enabled: false
  persistentVolume:
    config:
      enabled: false
  env:
    - name: ENROLL_KEY
      value: "${enroll_key}"
    - name: ENROLL_INSTANCE_NAME
      value: "k3s-cluster"
    - name: ENROLL_TAGS
      value: "k8s"
    - name: BOUNCER_KEY_traefik
      value: "${bouncer_key_traefik}"

config:
  "config.yaml.local": |
    db_config:
      type: postgresql
      user: crowdsec
      password: ${db_password}
      db_name: crowdsec
      host: postgres-cluster-rw-pooler.databases.svc.cluster.local
      port: 5432
