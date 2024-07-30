resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "argocd_application" "dashboard" {
  depends_on = [kubernetes_namespace.kubernetes_dashboard]

  metadata {
    name      = "k8s-dashboard"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kubernetes-dashboard"
    }

    source {
      repo_url        = "https://kubernetes.github.io/dashboard/"
      chart           = "kubernetes-dashboard"
      target_revision = "7.5.0"
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
    namespace = "kubernetes-dashboard"
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