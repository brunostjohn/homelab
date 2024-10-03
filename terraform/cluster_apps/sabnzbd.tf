resource "argocd_application" "sabnzbd" {
  metadata {
    name      = "sabnzbd"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.entertainment.metadata[0].name
    }

    source {
      repo_url = var.homelab_repo
      path     = "k8s/sabnzbd"

    }

    sync_policy {
      automated {
        self_heal   = true
        prune       = true
        allow_empty = true
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