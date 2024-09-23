module "ollama_helm" {
  source = "../helm_deployment"

  repo_url         = "https://helm.openwebui.com/"
  chart            = "open-webui"
  target_revision  = "3.1.16"
  namespace        = kubernetes_namespace.ai.metadata[0].name
  name             = "ollama"
  create_namespace = false
  values = templatefile("${path.module}/templates/ollama.yml.tpl", {
    global_fqdn          = var.global_fqdn
    client_id            = var.ollama_oidc_client_id
    client_secret        = var.ollama_oidc_client_secret
    google_pse_api_key   = var.ollama_google_pse_api_key
    google_pse_engine_id = var.ollama_google_pse_engine_id
    openid_provider_url  = "https://auth.${var.global_fqdn}/application/o/ollama/.well-known/openid-configuration"
  })

  create_ingress = false
}