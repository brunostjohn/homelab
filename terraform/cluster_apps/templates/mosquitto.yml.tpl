replicaCount: 1

image:
  repository: eclipse-mosquitto
  tag: 2.0.18
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  externalTrafficPolicy: ""

persistence:
  enabled: true
  storageClass: longhorn
  existingClaim: ${pvc}

config: |
  persistence true
  persistence_location /mosquitto/data/
  log_dest stdout
  listener 1883
  listener 9090
  protocol websockets

authentication:
  passwordEntries: |-
    zigbee2mqtt:${zigbee2mqtt_password_hash}
    homeassistant:${homeassistant_password_hash}
    octoprint:${octoprint_password_hash}
    exporter:${exporter_password_hash}

authorization:
  acls: |-
    user zigbee2mqtt
    topic readwrite zigbee2mqtt
    topic readwrite homeassistant
    pattern read cmnd/%u/#
    pattern write stat/%u/#
    pattern write tele/%u/#
    user homeassistant
    topic readwrite zigbee2mqtt
    topic readwrite homeassistant
    topic readwrite octoprint
    user octoprint
    topic readwrite homeassistant
    topic readwrite octoprint
    user exporter
    topic read $SYS

monitoring:
  podMonitor:
    enabled: true
  sidecar:
    enabled: true
    port: 9234
    envs:
      - name: MQTT_USER
        value: exporter
      - name: MQTT_PASS
        value: ${exporter_password}
      - name: BROKER_ENDPOINT
        value: tcp://mosquitto.mosquitto.svc.cluster.local:1883
    image:
      repository: sapcc/mosquitto-exporter
      tag: latest
      pullPolicy: IfNotPresent
    resources:
      limits:
        cpu: 300m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 64Mi