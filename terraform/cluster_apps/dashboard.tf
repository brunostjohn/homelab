resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "argocd_application" "dashboard" {
  depends_on = [kubernetes_namespace.kubernetes_dashboard]

  wait = true

  metadata {
    name      = "k8s-dashboard"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
    }

    source {
      repo_url        = "https://kubernetes.github.io/dashboard/"
      chart           = "kubernetes-dashboard"
      target_revision = "7.5.0"

      helm {
        values = var.k8s_dashboard_values
      }
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

resource "kubernetes_service_account" "dashboard_admin" {
  depends_on = [kubernetes_namespace.kubernetes_dashboard, argocd_application.dashboard]

  metadata {
    name      = "admin-user"
    namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "dashboard_admin_binding" {
  depends_on = [kubernetes_service_account.dashboard_admin]

  metadata {
    name = "admin-user"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dashboard_admin.metadata[0].name
    namespace = kubernetes_service_account.dashboard_admin.metadata[0].namespace
  }
}

resource "kubernetes_manifest" "dashboard_auth_middleware" {
  depends_on = [kubernetes_cluster_role_binding.dashboard_admin_binding]
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "dashboard-auth-middleware"
      namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
    }
    spec = {
      headers = {
        customRequestHeaders = {
          Authorization = "Bearer ${var.k8s_dashboard_token}"
        }
      }
    }
  }
}


resource "kubernetes_ingress_v1" "dashboard_ingress" {
  depends_on = [argocd_application.dashboard, kubernetes_cluster_role_binding.dashboard_admin_binding]

  wait_for_load_balancer = true

  metadata {
    namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
    name      = "k8s-dashboard"

    annotations = {
      "traefik.ingress.kubernetes.io/router.middlewares" = "${kubernetes_namespace.kubernetes_dashboard.metadata[0].name}-dashboard-auth-middleware@kubernetescrd"
    }
  }

  spec {
    rule {
      host = "k3s.local"
      http {
        path {
          backend {
            service {
              name = "k8s-dashboard-kong-proxy"
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