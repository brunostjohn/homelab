crds:
  enabled: true

prometheus:
  enabled: true
  servicemonitor:
    enabled: true

dns01RecursiveNameservers: "1.1.1.1:53,8.8.8.8:53"
dns01RecursiveNameserversOnly: true