resource "kubernetes_secret" "lidarr_exporter_secret" {
  metadata {
    name      = "lidarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.lidarr_api_key
  }
}

resource "argocd_application" "lidarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.lidarr_exporter_secret]

  metadata {
    name      = "lidarr"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/lidarr"
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