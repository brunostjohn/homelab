replicaCount: 1

service:
  type: ClusterIP
  externalTrafficPolicy: ""

persistence:
  enabled: true
  storageClass: longhorn
  existingClaim: ${pvc}

authentication:
  passwordEntries: |-
    zigbee2mqtt:${zigbee2mqtt_password_hash}
    homeassistant:${homeassistant_password_hash}
    octoprint:${octoprint_password_hash}

authorization:
  acls: |-
    user zigbee2mqtt
    topic readwrite zigbee2mqtt/#
    topic readwrite homeassistant/#
    user homeassistant
    topic readwrite zigbee2mqtt/#
    topic readwrite homeassistant/#
    topic readwrite octoprint/#
    user octoprint
    topic readwrite homeassistant/#
    topic readwrite octoprint/#

monitoring:
  podMonitor:
    enabled: false
  sidecar:
    enabled: false