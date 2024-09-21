resource "kubernetes_namespace" "mealie" {
  metadata {
    name = "mealie"
  }
}

resource "argocd_application" "mealie" {
  metadata {
    name      = "mealie"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/mealie"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.mealie.metadata[0].name
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

module "mealie_ingress" {
  depends_on = [argocd_application.mealie]
  source     = "../ingress"

  hosts     = ["mealie.zefirsroyal.cloud"]
  service   = "mealie"
  namespace = kubernetes_namespace.mealie.metadata[0].name
  port      = 9000
}