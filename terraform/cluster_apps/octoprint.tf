resource "argocd_application" "octoprint" {
  wait = true

  metadata {
    name      = "octoprint"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/octoprint"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.threedprint.metadata[0].name
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

module "octoprint_ingress" {
  depends_on = [argocd_application.octoprint]
  source     = "../ingress"

  hosts     = ["octoprint.local"]
  service   = "octoprint-service"
  namespace = kubernetes_namespace.threedprint.metadata[0].name
  port      = 80
}

module "spoolman_ingress" {
  depends_on = [argocd_application.octoprint]
  source     = "../ingress"

  hosts     = ["spoolman.local"]
  service   = "spoolman-service"
  namespace = kubernetes_namespace.threedprint.metadata[0].name
  port      = 8000
}