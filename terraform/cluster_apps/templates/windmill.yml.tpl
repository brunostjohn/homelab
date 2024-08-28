windmill:
  databaseUrl: postgresql://postgres:postgres@postgres-postgresql.databases.svc.cluster.local:5432/windmill
  appReplicas: 1
  lspReplicas: 1
  baseDomain: windmill.${global_fqdn}
  baseProtocol: https
  workerGroups:
    - name: "default"
      replicas: 2

ingress:
  enabled: true

postgresql:
  enabled: false
