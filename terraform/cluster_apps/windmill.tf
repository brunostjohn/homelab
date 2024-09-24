resource "kubernetes_namespace" "windmill" {
  metadata {
    name = "windmill"
  }
}

module "windmill_helm" {
  source = "../helm_deployment"

  name = "windmill"

  namespace        = kubernetes_namespace.windmill.metadata[0].name
  create_namespace = false

  chart           = "windmill"
  target_revision = "2.0.256"
  repo_url        = "https://windmill-labs.github.io/windmill-helm-charts/"
  values = templatefile("${path.module}/templates/windmill.yml.tpl", {
    "global_fqdn" = var.global_fqdn
    "db_password" = var.windmill_db_password
  })

  create_ingress = false
}