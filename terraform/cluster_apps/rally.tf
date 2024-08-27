resource "kubernetes_namespace" "rally" {
  metadata {
    name = "rally"
  }
}

resource "kubernetes_secret" "rally_secrets" {
  metadata {
    name      = "rally-secrets"
    namespace = kubernetes_namespace.rally.metadata[0].name
  }

  data = {
    "discovery_url"   = "https://auth.${var.global_fqdn}/application/o/rally/.well-known/openid-configuration"
    "client_id"       = var.rally_client_id
    "client_secret"   = var.rally_client_secret
    "secret_password" = var.rally_secret_password
    "smtp_password"   = var.smtp_password
  }
}

resource "kubernetes_config_map" "rally_config" {
  metadata {
    name      = "rally-config"
    namespace = kubernetes_namespace.rally.metadata[0].name
  }

  data = {
    "smtp_user"          = var.smtp_username
    "smtp_host"          = var.smtp_host
    "smtp_port"          = var.smtp_port
    "support_email"      = var.smtp_from
    "noreply_email"      = var.smtp_from
    "noreply_email_name" = "Rally @ Zefir's Cloud"
    "base_url"           = "https://rally.${var.global_fqdn}"
  }
}

resource "argocd_application" "rally" {
  depends_on = [kubernetes_secret.rally_secrets, kubernetes_config_map.rally_config]
  metadata {
    name      = "rally"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/rally"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.rally.metadata[0].name
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

module "rally_ingress" {
  depends_on = [argocd_application.rally]
  source     = "../ingress"

  namespace = kubernetes_namespace.rally.metadata[0].name

  service = "rally"
  port    = 3000
  hosts   = ["rally.${var.global_fqdn}"]
}