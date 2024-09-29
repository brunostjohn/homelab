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
  replicas: 3
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  dashboard:
    enabled: false
  persistentVolume:
    data:
      enabled: false
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
  notifications:
    slack.yaml: |
      type: slack

      name: slack_default
      log_level: info

      format: |
        {{range . -}}
        {{$alert := . -}}
        {{range .Decisions -}}
        {{if $alert.Source.Cn -}}
        :flag-{{$alert.Source.Cn}}: <https://www.whois.com/whois/{{.Value}}|{{.Value}}> will get {{.Type}} for next {{.Duration}} for triggering {{.Scenario}} on machine '{{$alert.MachineID}}'. <https://www.shodan.io/host/{{.Value}}|Shodan>{{end}}
        {{if not $alert.Source.Cn -}}
        :pirate_flag: <https://www.whois.com/whois/{{.Value}}|{{.Value}}> will get {{.Type}} for next {{.Duration}} for triggering {{.Scenario}} on machine '{{$alert.MachineID}}'.  <https://www.shodan.io/host/{{.Value}}|Shodan>{{end}}
        {{end -}}
        {{end -}}

      webhook: ${webhook_url}
