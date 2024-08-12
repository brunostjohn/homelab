resource "kubernetes_secret" "overseerr_exporter_secret" {
  metadata {
    name      = "overseerr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.overseerr_api_key
  }
}

resource "argocd_application" "overseerr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.overseerr_exporter_secret]

  metadata {
    name      = "overseerr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/overseerr"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.entertainment.metadata[0].name
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}

module "overseerr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.qbittorrent]

  service   = "overseerr"
  hosts     = ["den.${var.global_fqdn}"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 5055
}