resource "kubernetes_secret" "nocodb_secrets" {
  metadata {
    name      = "nocodb-secrets"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "NC_OIDC_CLIENT_ID"     = var.nocodb_oidc_client_id
    "NC_OIDC_CLIENT_SECRET" = var.nocodb_oidc_client_secret
    "NC_AUTH_JWT_SECRET"    = var.nocodb_auth_secret
    "NC_DB"                 = "pg://postgres-cluster-rw-pooler.databases.svc.cluster.local:5432?u=nocodb&p=${urlencode(var.nocodb_db_password)}&d=nocodb"
    "NC_S3_ACCESS_SECRET"   = var.nocodb_s3_access_secret
    "NC_SMTP_PASSWORD"      = var.smtp_password
  }
}

resource "kubernetes_config_map" "nocodb_config" {
  metadata {
    name      = "nocodb-config"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "NC_DISABLE_TELE"       = "true"
    "NC_PUBLIC_URL"         = "https://noco.${var.global_fqdn}"
    "NC_OIDC_CALLBACK_HOST" = "https://noco.${var.global_fqdn}"
    "NC_OIDC_PROVIDER_NAME" = "Zefir's Cloud"
    "NC_OIDC_ISSUER"        = "https://auth.${var.global_fqdn}/application/o/nocodb/"
    "NC_OIDC_TOKEN_URL"     = "https://auth.${var.global_fqdn}/application/o/token/"
    "NC_OIDC_AUTH_URL"      = "https://auth.${var.global_fqdn}/application/o/authorize/"
    "NC_OIDC_USERINFO_URL"  = "https://auth.${var.global_fqdn}/application/o/userinfo/"
    "NC_SMTP_FROM"          = var.smtp_from
    "NC_SMTP_HOST"          = var.smtp_host
    "NC_SMTP_PORT"          = var.smtp_port
    "NC_SMTP_USERNAME"      = var.smtp_username
    "NC_SMTP_SECURE"        = "true"
    "NC_SMTP_IGNORE_TLS"    = "false"
    "NC_SSO"                = "OIDC"
    "NC_DISABLE_EMAIL_AUTH" = "true"
    "NC_ADMIN_EMAIL"        = var.nocodb_admin_email
    "NC_REDIS_URL"          = "redis://:redis@redis-master.databases.svc.cluster.local:6379/10"
    "NC_S3_BUCKET_NAME"     = "nocodb-attachments"
    "NC_S3_REGION"          = "irrelevant"
    "NC_S3_ENDPOINT"        = "static.${var.global_fqdn}"
    "NC_S3_ACCESS_KEY"      = var.nocodb_s3_access_key
    "NC_SECURE_ATTACHMENTS" = "true"
    "NC_KEEP_CACHE"         = "true"
  }
}

resource "argocd_application" "nocodb" {
  depends_on = [kubernetes_secret.nocodb_secrets, kubernetes_config_map.nocodb_config]

  metadata {
    name      = "nocodb"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/nocodb"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.productivity.metadata[0].name
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

module "nocodb_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.nocodb]

  service   = "nocodb-svc"
  hosts     = ["noco.${var.global_fqdn}"]
  namespace = kubernetes_namespace.productivity.metadata[0].name
  port      = 8080
}