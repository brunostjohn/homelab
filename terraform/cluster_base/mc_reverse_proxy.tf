resource "kubernetes_namespace" "minecraft" {
  metadata {
    name = "minecraft"
  }
}

resource "argocd_application" "mc_reverse_proxy" {
  metadata {
    name      = "mc-reverse-proxy"
    namespace = "argocd"
  }

  wait = true

  spec {
    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/mc-reverse-proxy"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.minecraft.metadata[0].name
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