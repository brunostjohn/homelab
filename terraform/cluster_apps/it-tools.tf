resource "argocd_application" "it_tools" {
  metadata {
    name      = "it-tools"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/productivity/it-tools"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.productivity.metadata[0].name
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