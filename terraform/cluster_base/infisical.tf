resource "kubernetes_namespace" "infisical" {
  metadata {
    name = "infisical"
  }
}

resource "kubernetes_secret" "infisical" {
  metadata {
    name      = "infisical-secrets"
    namespace = kubernetes_namespace.infisical.metadata[0].name
  }

  data = {
    "AUTH_SECRET"                = var.infisical_auth_secret
    "ENCRYPTION_KEY"             = var.infisical_encryption_key
    "REDIS_URL"                  = "redis://:redis@redis-master.databases.svc.cluster.local:6379/15"
    "DB_CONNECTION_URI"          = "postgresql://infisical:${urlencode(var.infisical_db_password)}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/infisical"
    "SITE_URL"                   = "https://secrets.${var.global_fqdn}"
    "TELEMETRY_ENABLED"          = "false"
    "SMTP_HOST"                  = var.smtp_host
    "SMTP_PORT"                  = var.smtp_port
    "SMTP_FROM_ADDRESS"          = var.smtp_from
    "SMTP_FROM_NAME"             = "Secrets @ Zefir's Cloud"
    "SMTP_USERNAME"              = var.smtp_username
    "SMTP_PASSWORD"              = var.smtp_password
    "CLIENT_ID_GOOGLE_LOGIN"     = var.infisical_google_client_id
    "CLIENT_SECRET_GOOGLE_LOGIN" = var.infisical_google_client_secret
  }
}

module "infisical_helm" {
  source = "../helm_deployment"

  name            = "infisical"
  chart           = "infisical-standalone"
  repo_url        = "https://dl.cloudsmith.io/public/infisical/helm-charts/helm/charts/"
  target_revision = "1.0.8"
  values = templatefile("${path.module}/values/infisical.yml.tpl", {
    global_fqdn = var.global_fqdn
  })

  namespace        = kubernetes_namespace.infisical.metadata[0].name
  create_namespace = false

  create_ingress = false
}