resource "kubernetes_namespace" "octoprint" {
  metadata {
    name = "octoprint"
  }
}

resource "argocd_application" "octoprint" {
  depends_on = [kubernetes_namespace.octoprint]

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
      namespace = kubernetes_namespace.octoprint.metadata[0].name
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
  namespace = kubernetes_namespace.octoprint.metadata[0].name
  port      = 5000
}

module "spoolman_ingress" {
  depends_on = [argocd_application.octoprint]
  source     = "../ingress"

  hosts     = ["spoolman.local"]
  service   = "spoolman-service"
  namespace = kubernetes_namespace.octoprint.metadata[0].name
  port      = 8000
}

module "mjpeg_ingress" {
  depends_on = [argocd_application.octoprint]
  source     = "../ingress"

  hosts     = ["camera.octoprint.local"]
  service   = "mjpeg-streamer-service"
  namespace = kubernetes_namespace.octoprint.metadata[0].name
  port      = 8080
}