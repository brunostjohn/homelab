# module "mariadb_helm" {
#   depends_on = [module.floof_iscsi_helm]
#   source     = "../helm_deployment"

#   name             = "mariadb"
#   namespace        = kubernetes_namespace.databases.metadata[0].name
#   create_ingress   = false
#   create_namespace = false

#   chart           = "mariadb"
#   repo_url        = "https://charts.bitnami.com/bitnami"
#   target_revision = "19.0.5"
#   values          = file("${path.module}/values/mariadb.yml")
# }