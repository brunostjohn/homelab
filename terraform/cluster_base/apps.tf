resource "argocd_application" "cluster_base" {
  metadata {
    name      = "cluster-base"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = argocd_repository.homelab_github.repo
      path     = "apps/clusterBase"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
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
