module "reflector" {
  depends_on = [module.cert_manager]
  source     = "../helm_deployment"

  namespace        = "reflector"
  create_namespace = true

  name            = "reflector"
  chart           = "reflector"
  repo_url        = "https://emberstack.github.io/helm-charts"
  target_revision = "7.1.288"

  create_ingress = false
}