module "reloader_helm" {
  source = "../helm_deployment"

  name             = "reloader"
  namespace        = "reloader"
  create_namespace = true

  chart           = "reloader"
  target_revision = "1.0.121"
  repo_url        = "https://stakater.github.io/stakater-charts"
  values          = file("${path.module}/values/reloader.yml")

  create_ingress = false
}