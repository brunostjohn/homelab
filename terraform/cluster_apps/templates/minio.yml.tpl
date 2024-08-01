rootUser: ${username}
rootPassword: ${password}

resources:
  requests:
    memory: 2Gi

replicas: 2

persistence:
  enabled: true
  storageClass: ${sc_name}
  size: ${size}

securityContext:
  enabled: false