resource "kubernetes_namespace" "longhorn" {
  metadata {
    name = "longhorn-system"
  }
}

resource "argocd_application" "longhorn" {
  depends_on = [argocd_application.metallb, kubernetes_namespace.longhorn]

  wait = true

  metadata {
    name      = "longhorn"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url        = "https://charts.longhorn.io"
      chart           = "longhorn"
      target_revision = "1.6.2"

      helm {
        values = var.longhorn_values
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "longhorn-system"
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
}

resource "kubernetes_secret" "longhorn_auth" {
  metadata {
    namespace = kubernetes_namespace.longhorn.metadata[0].name
    name      = "basic-auth"
  }

  data = {
    auth = var.longhorn_auth_secret
  }
}

resource "kubernetes_ingress_v1" "longhorn_ingress" {
  depends_on = [argocd_application.longhorn]

  metadata {
    namespace = "longhorn-system"
    name      = "longhorn-ingress"
  }

  wait_for_load_balancer = true

  spec {
    rule {
      host = "longhorn.local"
      http {
        path {
          backend {
            service {
              name = "longhorn-frontend"
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