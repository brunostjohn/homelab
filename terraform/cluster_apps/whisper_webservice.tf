resource "kubernetes_namespace" "ai" {
  metadata {
    name = "ai"
  }
}

resource "argocd_application" "whisper_webservice" {
  metadata {
    name      = "whisper-webservice"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/whisper-webservice"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.ai.metadata[0].name
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