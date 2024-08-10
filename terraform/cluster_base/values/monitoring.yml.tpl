alertmanager:
  config:
    global:
      resolve_timeout: 5m
    inhibit_rules:
      - source_matchers:
          - 'severity = critical'
        target_matchers:
          - 'severity =~ warning|info'
        equal:
          - 'namespace'
          - 'alertname'
      - source_matchers:
          - 'severity = warning'
        target_matchers:
          - 'severity = info'
        equal:
          - 'namespace'
          - 'alertname'
      - source_matchers:
          - 'alertname = InfoInhibitor'
        target_matchers:
          - 'severity = info'
        equal:
          - 'namespace'
      - target_matchers:
          - 'alertname = InfoInhibitor'
    route:
      group_by: ['namespace']
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
    - '/etc/alertmanager/config/*.tmpl'
  storage:
    volumeClaimTemplate:
      storageClassName: nfs-jabberwock-subpath
      resources:
        requests:
          storage: 512Mi

grafana:
  defaultDashboardsEnabled: false
  ingress:
    enabled: true
    ingressClassName: traefik
    hosts:
      - grafana.${global_fqdn}
  persistance:
    enabled: true
    storageClassName: nfs-jabberwock-subpath
    size: 1Gi
  grafana.ini:
    server:
      root_url: https://grafana.${global_fqdn}

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
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: nfs-jabberwock-subpath
          resources:
            requests:
              storage: 4Gi