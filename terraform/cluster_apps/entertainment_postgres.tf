module "entertainment_postgres" {
  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.entertainment.metadata[0].name
  name             = "entertainment-postgres"
  create_namespace = false
  create_ingress   = false

  chart           = "postgresql"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "15.5.21"
  values          = file("${path.module}/values/entertainment-postgres.yml")
}