module "redis" {
  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.databases.metadata[0].name
  name             = "redis"
  create_namespace = false
  create_ingress   = false

  chart           = "redis"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "20.0.3"
  values          = file("${path.module}/values/redis.yml")
}