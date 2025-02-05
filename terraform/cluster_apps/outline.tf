resource "kubernetes_namespace" "outline" {
  metadata {
    name = "outline"
  }
}

resource "kubernetes_config_map" "outline" {
  metadata {
    name      = "outline-config"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }

  data = {
    "NODE_ENV"                  = "production"
    "PGSSLMODE"                 = "disable"
    "REDIS_URL"                 = "redis://:redis@redis-master.databases.svc.cluster.local:6379/7"
    "URL"                       = "https://docs.${var.global_fqdn}"
    "FILE_STORAGE"              = "s3"
    "AWS_REGION"                = "doesntmatter"
    "AWS_S3_UPLOAD_BUCKET_URL"  = "https://static.${var.global_fqdn}"
    "AWS_S3_UPLOAD_BUCKET_NAME" = "outline"
    "AWS_S3_FORCE_PATH_STYLE"   = "true"
    "AWS_S3_ACL"                = "private"
    "OIDC_CLIENT_ID"            = var.outline_oidc_client_id
    "OIDC_AUTH_URI"             = "https://auth.${var.global_fqdn}/application/o/authorize/"
    "OIDC_TOKEN_URI"            = "https://auth.${var.global_fqdn}/application/o/token/"
    "OIDC_USERINFO_URI"         = "https://auth.${var.global_fqdn}/application/o/userinfo/"
    "OIDC_LOGOUT_URI"           = "https://auth.${var.global_fqdn}/application/o/outline/end-session/"
    "OIDC_USERNAME_CLAIM"       = "preferred_username"
    "OIDC_DISPLAY_NAME"         = "Zefir's Cloud"
    "SMTP_HOST"                 = var.smtp_host
    "SMTP_PORT"                 = var.smtp_port
    "SMTP_USERNAME"             = var.smtp_username
    "SMTP_FROM_EMAIL"           = "noreply@${var.global_fqdn}"
    "SMTP_SECURE"               = "false"
    "SMTP_TLS_CIPHERS"          = "TLSv1.2"
    "FORCE_HTTPS"               = "false"
  }
}

resource "kubernetes_secret" "outline" {
  metadata {
    name      = "outline-secrets"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }

  data = {
    "SECRET_KEY"            = var.outline_secret_key
    "UTILS_SECRET"          = var.outline_utils_secret
    "AWS_ACCESS_KEY_ID"     = var.outline_aws_access_key_id
    "AWS_SECRET_ACCESS_KEY" = var.outline_aws_secret_access_key
    "OIDC_CLIENT_SECRET"    = var.outline_oidc_client_secret
    "SMTP_PASSWORD"         = var.smtp_password
    "DATABASE_URL"          = "postgres://outline:${urlencode(var.outline_db_password)}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/outline"
  }
}

resource "argocd_application" "outline" {
  depends_on = [kubernetes_secret.outline, kubernetes_config_map.outline]

  metadata {
    name      = "outline"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/productivity/outline"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.entertainment.metadata[0].name
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

module "outline_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.outline]

  service   = "outline"
  hosts     = ["docs.${var.global_fqdn}"]
  namespace = kubernetes_namespace.outline.metadata[0].name
  port      = 3000
}