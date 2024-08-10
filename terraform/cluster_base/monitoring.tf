module "kube_prometheus_helm" {
  depends_on = [argocd_application.longhorn]
  source     = "../helm_deployment"

  namespace        = "monitoring"
  create_namespace = true

  name            = "monitoring"
  chart           = "kube-prometheus-stack"
  repo_url        = "https://prometheus-community.github.io/helm-charts"
  target_revision = "61.7.0"

  server_side_apply = true

  project = argocd_project.cluster_mgmt.metadata[0].name

  values = templatefile("${path.module}/values/monitoring.yml.tpl", {
    global_fqdn         = var.global_fqdn,
    namespace           = "monitoring",
    discord_webhook_url = var.alertmanager_discord_webhook_url,
  })

  create_ingress = false
}