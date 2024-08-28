module "keda_helm" {
  source = "../helm_deployment"

  namespace        = "keda"
  create_namespace = true

  name              = "keda"
  chart             = "keda"
  repo_url          = "https://kedacore.github.io/charts"
  target_revision   = "2.15.1"
  server_side_apply = true

  create_ingress = false
}