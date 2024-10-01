resource "kubernetes_config_map" "zipline" {
  metadata {
    name      = "zipline-config"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "DATASOURCE_S3_ACCESS_KEY_ID" = var.zipline_s3_access_key_id
    "DATASOURCE_S3_ENDPOINT"      = "minio-svc.minio.svc.cluster.local"
    "DATASOURCE_S3_PORT"          = "9000"
    "DATASOURCE_S3_BUCKET"        = "zipline-uploads"
    "DATASOURCE_S3_FORCE_S3_PATH" = "true"
    "DATASOURCE_S3_USE_SSL"       = "false"
    "FEATURES_INVITES"            = "false"
    # "FEATURES_OAUTH_REGISTRATION" = "true"
    # "FEATURES_OAUTH_LOGIN_ONLY" = "true"
    # "FEATURES_USER_REGISTRATION" = "false"
    "FEATURES_ROBOTS_TXT" = "true"
    # "OAUTH_BYPASS_LOCAL_LOGIN" = "true"
  }
}

resource "kubernetes_secret" "zipline" {
  metadata {
    name      = "zipline-secrets"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "DATASOURCE_S3_SECRET_ACCESS_KEY" = var.zipline_s3_secret_access_key
    "CORE_SECRET"                     = var.zipline_core_secret
    "DATABASE_URL"               = "postgres://zipline:${urlencode(var.zipline_db_password)}@postgres-cluster-rw-pooler.databases.svc.cluster.local:5432/zipline"
  }
}

resource "argocd_application" "zipline" {
  metadata {
    name      = "zipline"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/zipline"
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

resource "kubernetes_manifest" "zipline_ingress" {
  depends_on = [argocd_application.zipline]

  manifest = {
    metadata = {
      name      = "zipline-ingress"
      namespace = kubernetes_namespace.productivity.metadata[0].name
    }

    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"

    spec = {
      tls = [
        {
          hosts = [
            "iam.${var.second_fqdn}"
          ]
          secretName = "second-prod"
        }
      ]
      rules = [
        {
          host = "iam.${var.second_fqdn}"
          http = {
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "zipline"
                    port = {
                      number = 3000
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
}