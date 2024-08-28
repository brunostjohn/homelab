resource "kubernetes_namespace" "paperless" {
  metadata {
    name = "paperless"
  }
}

resource "kubernetes_config_map" "paperless" {
  metadata {
    name      = "paperless-config"
    namespace = kubernetes_namespace.paperless.metadata.0.name
  }

  data = {
    "PAPERLESS_URL" = "https://paperless.${var.global_fqdn}"
  }
}

resource "kubernetes_secret" "paperless" {
  metadata {
    name      = "paperless-secrets"
    namespace = kubernetes_namespace.paperless.metadata.0.name
  }

  data = {
    "PAPERLESS_SOCIALACCOUNT_PROVIDERS" = jsonencode({
      "openid_connect" = {
        "APPS" = [
          {
            "provider_id" = "zefirs-cloud"
            "name"        = "Zefir's Cloud"
            "client_id"   = var.paperless_oidc_client_id
            "secret"      = var.paperless_oidc_client_secret
            "settings" = {
              "server_url" = "https://auth.${var.global_fqdn}/application/o/paperless-ngx/.well-known/openid-configuration"
            }
          }
        ]
        "OAUTH_PKCE_ENABLED" = "True"
      }
    })
    "PAPERLESS_SECRET_KEY" = var.paperless_secret_key
  }
}

resource "argocd_application" "paperless" {
  depends_on = [kubernetes_config_map.paperless, kubernetes_secret.paperless]

  metadata {
    name      = "paperless"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/paperless"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.paperless.metadata[0].name
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

module "paperless_ingress" {
  depends_on = [argocd_application.paperless]
  source     = "../ingress"

  hosts     = ["paperless.${var.global_fqdn}"]
  port      = 8000
  namespace = kubernetes_namespace.paperless.metadata[0].name
  service   = "paperless"
}