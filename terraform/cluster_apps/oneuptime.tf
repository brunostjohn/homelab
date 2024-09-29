resource "kubernetes_namespace" "oneuptime" {
  metadata {
    name = "oneuptime"
  }
}

resource "kubernetes_secret" "oneuptime_redis" {
  metadata {
    name      = "oneuptime-redis"
    namespace = kubernetes_namespace.oneuptime.metadata[0].name
  }

  data = {
    "password" = "redis"
  }
}

module "oneuptime_helm" {
  source = "../helm_deployment"

  repo_url        = "https://helm-chart.oneuptime.com/"
  chart           = "oneuptime"
  target_revision = "7.0.3140"
  values = templatefile("${path.module}/templates/oneuptime.yml.tpl", {
    global_fqdn = var.global_fqdn
    db_password = var.oneuptime_db_password
  })

  auto_sync = false
  wait      = false

  namespace        = kubernetes_namespace.oneuptime.metadata[0].name
  create_namespace = false
  name             = "oneuptime"

  create_ingress = false
}