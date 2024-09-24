windmill:
  databaseUrl: postgresql://windmill:${db_password}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/windmill
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
