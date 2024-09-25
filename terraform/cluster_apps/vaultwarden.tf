resource "kubernetes_namespace" "vaultwarden" {
  metadata {
    name = "vaultwarden"
  }
}

resource "kubernetes_config_map" "vaultwarden" {
  metadata {
    name      = "vaultwarden-config"
    namespace = kubernetes_namespace.vaultwarden.metadata[0].name
  }

  data = {
    "DOMAIN"               = "passwords.${var.global_fqdn}"
    "PUSH_INSTALLATION_ID" = var.vaultwarden_installation_id
    "SMTP_HOST"            = var.smtp_host
    "SMTP_FROM"            = var.smtp_from
    "SMTP_USERNAME"        = var.smtp_username
    "SMTP_PORT"            = var.smtp_port
    "SMTP_SECURITY"        = "starttls"
  }
}

resource "kubernetes_secret" "vaultwarden" {
  metadata {
    name      = "vaultwarden-secrets"
    namespace = kubernetes_namespace.vaultwarden.metadata[0].name
  }

  data = {
    "DATABASE_URL"          = "postgresql://vaultwarden:${urlencode(var.vaultwarden_db_password)}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/vaultwarden"
    "PUSH_INSTALLATION_KEY" = var.vaultwarden_installation_key
    "SMTP_PASSWORD"         = var.smtp_password
  }
}

resource "argocd_application" "vaultwarden" {
  depends_on = [kubernetes_secret.vaultwarden, kubernetes_config_map.vaultwarden]

  metadata {
    name      = "vaultwarden"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/vaultwarden"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.vaultwarden.metadata[0].name
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

module "vaultwarden_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.vaultwarden]

  service   = "vaultwarden"
  hosts     = ["passwords.${var.global_fqdn}"]
  namespace = kubernetes_namespace.vaultwarden.metadata[0].name
  port      = 80
}