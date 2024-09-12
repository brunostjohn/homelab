resource "kubernetes_namespace" "nocodb" {
  metadata {
    name = "nocodb"
  }
}

resource "kubernetes_secret" "nocodb_secrets" {
  metadata {
    name      = "nocodb-secrets"
    namespace = kubernetes_namespace.nocodb.metadata[0].name
  }

  data = {
    "NC_OIDC_CLIENT_ID"     = var.nocodb_oidc_client_id
    "NC_OIDC_CLIENT_SECRET" = var.nocodb_oidc_client_secret
    "NC_SMTP_PASSWORD"      = var.smtp_password
    "NC_AUTH_JWT_SECRET"    = var.nocodb_auth_secret
    "NC_DB"                 = "pg://nocodb-postgresql.nocodb.svc.cluster.local:5432?u=postgres&p=postgres&d=nocodb"
  }
}

resource "kubernetes_config_map" "nocodb_config" {
  metadata {
    name      = "nocodb-config"
    namespace = kubernetes_namespace.nocodb.metadata[0].name
  }

  data = {
    "NC_DISABLE_TELE"       = "true"
    "NC_PUBLIC_URL"         = "https://noco.${var.global_fqdn}"
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
    "NC_SSO"                = "OIDC"
  }
}

# resource "argocd_application" "nocodb" {
#   depends_on = [kubernetes_namespace.nocodb, kubernetes_secret.nocodb_secrets, kubernetes_config_map.nocodb_config]

#   metadata {
#     name      = "nocodb"
#     namespace = "argocd"
#   }

#   spec {
#     source {
#       repo_url = var.homelab_repo
#       path     = "k8s/nocodb"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.nocodb.metadata[0].name
#     }

#     sync_policy {
#       automated {
#         prune     = true
#         self_heal = true
#       }

#       retry {
#         limit = "5"
#         backoff {
#           duration     = "30s"
#           max_duration = "2m"
#           factor       = "2"
#         }
#       }
#     }
#   }
# }

module "nocodb_ingress" {
  source     = "../ingress"
  # depends_on = [argocd_application.nocodb]

  service   = "nocodb-svc"
  hosts     = ["noco.${var.global_fqdn}"]
  namespace = kubernetes_namespace.nocodb.metadata[0].name
  port      = 8080
}