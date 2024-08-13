resource "kubernetes_namespace" "homepage" {
  metadata {
    name = "homepage"
  }
}

resource "argocd_application" "homepage" {
  depends_on = [kubernetes_namespace.homepage]

  metadata {
    name      = "homepage"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/homepage"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.homepage.metadata[0].name
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