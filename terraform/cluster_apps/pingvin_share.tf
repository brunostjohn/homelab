resource "kubernetes_namespace" "pingvin_share" {
  metadata {
    name = "pingvin-share"
  }
}

resource "argocd_application" "pingvin_share" {
  metadata {
    name      = "pingvin-share"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.pingvin_share.metadata[0].name
    }

    source {
      repo_url = var.homelab_repo
      path     = "k8s/personal-cloud/pingvin-share"

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

module "pingvin_ingress" {
  source = "../ingress"

  service   = "pingvin-share"
  port      = 3000
  hosts     = ["share.${var.global_fqdn}"]
  namespace = kubernetes_namespace.pingvin_share.metadata[0].name
}