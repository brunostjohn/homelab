resource "kubernetes_namespace" "coder" {
  metadata {
    name = "coder"
  }
}

module "coder_helm" {
  source = "../helm_deployment"

  chart           = "coder"
  repo_url        = "https://helm.coder.com/v2"
  target_revision = "2.15.0"

  namespace        = kubernetes_namespace.coder.metadata[0].name
  create_namespace = false
  name             = "coder"
  create_ingress   = false

  values = templatefile("${path.module}/templates/coder.yml.tpl", {
    global_fqdn        = var.global_fqdn
    db_password        = urlencode(var.coder_db_password)
    oidc_client_id     = var.coder_oidc_client_id
    oidc_client_secret = var.coder_oidc_client_secret
  })
}