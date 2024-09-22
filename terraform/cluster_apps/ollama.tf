module "ollama_helm" {
  source = "../helm_deployment"

  repo_url         = "https://helm.openwebui.com/"
  chart            = "open-webui"
  target_revision  = "3.1.16"
  namespace        = "ollama"
  name             = "ollama"
  create_namespace = true
  values = templatefile("${path.module}/templates/ollama.yml.tpl", {
    global_fqdn         = var.global_fqdn
    client_id           = var.ollama_oidc_client_id
    client_secret       = var.ollama_oidc_client_secret
    openid_provider_url = "https://auth.${var.global_fqdn}/application/o/ollama/.well-known/openid-configuration"
  })

  create_ingress = false
}