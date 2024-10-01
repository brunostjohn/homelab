alertmanager:
  ingress:
    enabled: true
    hosts:
      - alertmanager.local
  config:
    global:
      resolve_timeout: 5m
    inhibit_rules:
      - source_matchers:
          - "severity = critical"
        target_matchers:
          - "severity =~ warning|info"
        equal:
          - "namespace"
          - "alertname"
      - source_matchers:
          - "severity = warning"
        target_matchers:
          - "severity = info"
        equal:
          - "namespace"
          - "alertname"
      - source_matchers:
          - "alertname = InfoInhibitor"
        target_matchers:
          - "severity = info"
        equal:
          - "namespace"
      - target_matchers:
          - "alertname = InfoInhibitor"
    route:
      group_by: ["namespace"]
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 12h
      receiver: discord
      routes:
        - receiver: discord
          matchers:
            - alertname = "Watchdog"
    receivers:
      - name: discord
        discord_configs:
          - webhook_url: ${discord_webhook_url}
    templates:
      - "/etc/alertmanager/config/*.tmpl"
  storage:
    volumeClaimTemplate:
      storageClassName: nfs-jabberwock-subpath
      resources:
        requests:
          storage: 512Mi

grafana:
  imageRenderer:
    enabled: true
  initChownData:
    enabled: false
  defaultDashboardsEnabled: false
  ingress:
    enabled: true
    ingressClassName: traefik
    hosts:
      - grafana.${global_fqdn}
  persistence:
    enabled: false
  securityContext:
    fsGroup: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    runAsUser: 1001
    seccompProfile:
      type: RuntimeDefault
  extraSecretMounts:
    - name: grafana-secrets
      secretName: grafana-secrets
      defaultMode: 0440
      mountPath: /etc/secrets/grafana-secrets
      readOnly: true
  grafana.ini:
    server:
      root_url: https://grafana.${global_fqdn}
    analytics:
      reporting_enabled: false
      feedback_links_enabled: false
    database:
      type: postgres
      host: postgres-cluster-rw-pooler.databases.svc.cluster.local
      name: grafana
      user: grafana
      password: $__file{/etc/secrets/grafana-secrets/db_password}
    remote_caching:
      type: redis
      connstr: addr=redis-master.databases.svc.cluster.local:6379,pool_size=100,db=13,ssl=false

kubeEtcd:
  enabled: true
  endpoints:
    - 10.0.0.2
  service:
    enabled: true
    port: 2381
    targetPort: 2381

prometheusOperator:
  enabled: true
  tls:
    enabled: false
  admissionWebhooks:
    certManager:
      enabled: true

prometheus:
  prometheusSpec:
    ruleNamespaceSelector: {}
    ruleSelectorNilUsesHelmValues: false
    ruleSelector: {}
    serviceMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelector: {}
    serviceMonitorNamespaceSelector: {}
    podMonitorSelectorNilUsesHelmValues: false
    podMonitorSelector: {}
    podMonitorNamespaceSelector: {}
    probeSelectorNilUsesHelmValues: false
    probeSelector: {}
    probeNamespaceSelector: {}
    scrapeConfigSelectorNilUsesHelmValues: false
    scrapeConfigSelector: {}
    scrapeConfigNamespaceSelector: {}
    securityContext:
      runAsGroup: 1001
      runAsNonRoot: true
      runAsUser: 1001
      fsGroup: 1001
      seccompProfile:
        type: RuntimeDefault
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: nfs-jabberwock-subpath
          resources:
            requests:
              storage: 4Gi
