resource "kubernetes_namespace" "mealie" {
  metadata {
    name = "mealie"
  }
}

resource "kubernetes_config_map" "mealie" {
  metadata {
    name      = "mealie-config"
    namespace = kubernetes_namespace.mealie.metadata[0].name
  }

  data = {
    "BASE_URL"               = "https://mealie.${var.global_fqdn}"
    "SMTP_HOST"              = var.smtp_host
    "SMTP_PORT"              = var.smtp_port
    "SMTP_FROM_EMAIL"        = var.smtp_from
    "SMTP_USER"              = var.smtp_username
    "OIDC_CONFIGURATION_URL" = "https://auth.${var.global_fqdn}/application/o/mealie/.well-known/openid-configuration"
    "OIDC_CLIENT_ID"         = var.mealie_oidc_client_id
  }
}

resource "kubernetes_secret" "mealie" {
  metadata {
    name      = "mealie-secrets"
    namespace = kubernetes_namespace.mealie.metadata[0].name
  }

  data = {
    "SMTP_PASSWORD"     = var.smtp_password
    "POSTGRES_PASSWORD" = urlencode(var.mealie_db_password)
  }
}

resource "argocd_application" "mealie" {
  depends_on = [kubernetes_config_map.mealie, kubernetes_secret.mealie]

  metadata {
    name      = "mealie"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/personal-cloud/mealie"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.mealie.metadata[0].name
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

module "mealie_ingress" {
  depends_on = [argocd_application.mealie]
  source     = "../ingress"

  hosts     = ["mealie.${var.global_fqdn}"]
  service   = "mealie"
  namespace = kubernetes_namespace.mealie.metadata[0].name
  port      = 9000
}