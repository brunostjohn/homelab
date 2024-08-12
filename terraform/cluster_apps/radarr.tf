resource "kubernetes_secret" "radarr_exporter_secret" {
  metadata {
    name      = "radarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.radarr_api_key
  }
}

resource "argocd_application" "radarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.radarr_exporter_secret]

  metadata {
    name      = "radarr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/radarr"
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