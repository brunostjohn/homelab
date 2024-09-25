resource "kubernetes_namespace" "memos" {
  metadata {
    name = "memos"
  }
}

resource "kubernetes_secret" "memos" {
  metadata {
    name      = "memos-secrets"
    namespace = kubernetes_namespace.memos.metadata[0].name
  }

  data = {
    "db_connection_url" = "postgresql://memos:${urlencode(var.memos_db_password)}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/memos"
  }
}

resource "argocd_application" "memos" {
  depends_on = [kubernetes_secret.memos]

  metadata {
    name      = "memos"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/memos"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.memos.metadata[0].name
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

module "memos_ingress" {
  depends_on = [argocd_application.memos]
  source     = "../ingress"

  hosts     = ["memos.zefirsroyal.cloud"]
  service   = "memos"
  namespace = kubernetes_namespace.memos.metadata[0].name
  port      = 5230
}