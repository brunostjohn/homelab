infisical:
  image:
    repository: infisical/infisical
    tag: "v0.86.1-postgres"
    pullPolicy: IfNotPresent

ingress:
  enabled: true
  ingressClassName: traefik
  hostName: secrets.${global_fqdn}

postgresql:
  enabled: false

redis:
  enabled: false