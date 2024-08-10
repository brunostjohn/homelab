resource "kubernetes_manifest" "helm_chart_config_traefik" {
  depends_on = [module.crowdsec]

  manifest = {
    apiVersion = "helm.cattle.io/v1"
    kind       = "HelmChartConfig"
    metadata = {
      name      = "traefik"
      namespace = "kube-system"
    }
    spec = {
      valuesContent = var.traefik_values
    }
  }
}
