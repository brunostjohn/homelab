module "obico_helm" {
  source = "../helm_deployment"

  chart           = "obico"
  repo_url        = "https://charts.gabe565.com"
  target_revision = "0.4.0"
  values = templatefile("${path.module}/templates/obico.yml.tpl", {
    global_fqdn   = var.global_fqdn
    smtp_host     = var.smtp_host
    smtp_port     = var.smtp_port
    smtp_user     = var.smtp_username
    smtp_password = var.smtp_password
  })

  name             = "obico"
  namespace        = kubernetes_namespace.threedprint.metadata[0].name
  create_namespace = false

  create_ingress = false
}