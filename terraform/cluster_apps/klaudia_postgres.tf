resource "kubernetes_namespace" "klaudia_funproject" {
  metadata {
    name = "klaudia-funproject"
  }
}

module "klaudia_postgres" {
  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.klaudia_funproject.metadata[0].name
  name             = "klaudia-funproject-postgres"
  create_namespace = false
  create_ingress   = false

  chart           = "postgresql"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "15.5.21"
  values          = file("${path.module}/values/klaudia-postgres.yml")
}