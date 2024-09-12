resource "kubernetes_namespace" "romm" {
  metadata {
    name = "romm"
  }
}

resource "kubernetes_secret" "romm" {
  metadata {
    name      = "romm-secrets"
    namespace = kubernetes_namespace.romm.metadata[0].name
  }

  data = {
    "ROMM_AUTH_SECRET_KEY" = var.romm_auth_secret_key
    "IGDB_CLIENT_ID"       = var.romm_igdb_client_id
    "IGDB_CLIENT_SECRET"   = var.romm_igdb_client_secret
    "MOBYGAMES_API_KEY"    = var.romm_mobygames_api_key
    "STEAMGRIDDB_API_KEY"  = var.romm_steamgriddb_api_key
    "ROMM_HOST"            = "romm.${var.global_fqdn}"
  }
}

resource "argocd_application" "romm" {
  depends_on = [kubernetes_secret.romm]

  metadata {
    name      = "romm"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/romm"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.romm.metadata[0].name
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

module "romm_ingress" {
  depends_on = [argocd_application.romm]
  source     = "../ingress"

  service   = "romm"
  port      = 8080
  hosts     = ["romm.${var.global_fqdn}"]
  namespace = "romm"
}