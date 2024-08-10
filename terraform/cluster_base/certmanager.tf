module "cert_manager" {
  source = "../helm_deployment"

  namespace        = "cert-manager"
  create_namespace = true

  name            = "cert-manager"
  chart           = "cert-manager"
  repo_url        = "https://charts.jetstack.io"
  target_revision = "v1.15.2"

  project = argocd_project.security.metadata[0].name

  create_ingress = false

  values = templatefile("${path.module}/values/certmanager.yml.tpl", {
    global_fqdn = var.global_fqdn
  })
}