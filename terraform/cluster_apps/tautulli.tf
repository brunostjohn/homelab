resource "kubernetes_secret" "tautulli" {
  metadata {
    name      = "tautulli"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    api-key = var.tautulli_api_key
  }
}

resource "argocd_application" "tautulli" {
  depends_on = [kubernetes_secret.tautulli]

  metadata {
    name      = "tautulli"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/tautulli"
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

module "tautulli_ingress" {
  depends_on = [argocd_application.tautulli]

  source = "../ingress"

  service   = "tautulli"
  hosts     = ["tautulli.${var.global_fqdn}"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 5690
}