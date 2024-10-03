resource "kubernetes_config_map" "zipline" {
  metadata {
    name      = "zipline-config"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "DATASOURCE_TYPE"            = "local"
    "DATASOURCE_LOCAL_DIRECTORY" = "./uploads"
    "OAUTH_OIDC_CLIENT_ID"       = var.zipline_oidc_client_id
    "OAUTH_OIDC_AUTHORIZE_URL"   = "https://auth.${var.global_fqdn}/application/o/authorize/"
    "OAUTH_OIDC_USERINFO_URL"    = "https://auth.${var.global_fqdn}/application/o/userinfo/"
    "OAUTH_OIDC_TOKEN_URL"       = "https://auth.${var.global_fqdn}/application/o/token/"
    "CORE_HOSTNAME"              = "0.0.0.0"
  }
}

resource "kubernetes_secret" "zipline" {
  metadata {
    name      = "zipline-secrets"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "OAUTH_OIDC_CLIENT_SECRET" = var.zipline_oidc_client_secret
    "CORE_SECRET"              = var.zipline_core_secret
    "DATABASE_URL"             = "postgres://zipline:${urlencode(var.zipline_db_password)}@postgres-cluster-rw.databases.svc.cluster.local:5432/zipline?sslmode=disable"
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