module "vault_helm" {
  depends_on = [argocd_application.longhorn]
  source     = "../helm_deployment"

  namespace        = "vault"
  create_namespace = true

  name              = "vault"
  chart             = "vault"
  repo_url          = "https://helm.releases.hashicorp.com"
  target_revision   = "0.28.1"
  server_side_apply = true
  values = templatefile("${path.module}/values/vault.yml.tpl", {
    global_fqdn = var.global_fqdn
  })

  create_ingress = false
  wait           = false
}