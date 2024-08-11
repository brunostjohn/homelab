container_runtime: containerd

tls:
  enabled: true
  bouncer:
    reflector:
      namespaces: ["kube-system"]

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
    enabled: true
    ingress:
      host: crowdsec.local
      enabled: true
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