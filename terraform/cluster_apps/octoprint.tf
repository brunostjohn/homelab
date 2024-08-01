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
      namespace = kubernetes_namespace.octoprint.metadata.0.name
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

resource "kubernetes_ingress_v1" "octoprint_ingress" {
  depends_on = [argocd_application.octoprint]

  wait_for_load_balancer = true

  metadata {
    namespace = kubernetes_namespace.octoprint.metadata[0].name
    name      = "octoprint"
  }

  spec {
    rule {
      host = "octoprint.local"
      http {
        path {
          backend {
            service {
              name = "octoprint-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}