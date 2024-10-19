resource "kubernetes_secret" "silly_bot" {
  metadata {
    name      = "silly-bot-secrets"
    namespace = "default"
  }

  data = {
    "INFISICAL_CLIENT_ID"     = var.silly_bot_infisical_client_id
    "INFISICAL_CLIENT_SECRET" = var.silly_bot_infisical_client_secret
    "INFISICAL_PROJECT_ID"    = var.silly_bot_infisical_project_id
    "DATABASE_URL"            = "postgresql://sillybot:${var.silly_bot_database_password}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/sillybot"
  }
}

resource "argocd_application" "silly_bot" {
  depends_on = [kubernetes_secret.silly_bot]

  metadata {
    name      = "silly-bot"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/silly-bot"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
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

module "silly_bot_ingress" {
  depends_on = [argocd_application.silly_bot]
  source     = "../ingress"

  service   = "silly-bot"
  port      = 3000
  hosts     = ["bullybotis.${var.second_fqdn}"]
  namespace = "default"
}
