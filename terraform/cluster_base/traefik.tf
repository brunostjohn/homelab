resource "kubernetes_manifest" "traefik_https_redirect" {
  manifest = yamldecode(file("${path.module}/files/https-middleware.yml"))
}

resource "kubernetes_manifest" "helm_chart_config_traefik" {
  depends_on = [module.crowdsec]

  field_manager {
    force_conflicts = true
  }

  manifest = {
    apiVersion = "helm.cattle.io/v1"
    kind       = "HelmChartConfig"
    metadata = {
      name      = "traefik"
      namespace = "kube-system"
    }
    spec = {
      valuesContent = templatefile("${path.module}/values/traefik.yml.tpl", {
        cluster_ip = var.cluster_loadbalancer_ip
      })
    }
  }
}
