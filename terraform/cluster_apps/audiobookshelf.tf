resource "argocd_application" "audiobookshelf" {
  depends_on = [kubernetes_namespace.entertainment]

  metadata {
    name      = "audiobookshelf"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/audiobookshelf"
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

module "audiobookshelf_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.audiobookshelf]

  service   = "audiobookshelf"
  hosts     = ["audiobookshelf.${var.global_fqdn}"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 80
}