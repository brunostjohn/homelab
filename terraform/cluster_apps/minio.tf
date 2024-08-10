resource "kubernetes_namespace" "minio" {
  metadata {
    name = "minio"
  }
}

resource "argocd_application" "minio" {
  depends_on = [kubernetes_namespace.minio]

  wait = true

  metadata {
    name      = "minio"
    namespace = "argocd"
  }

  spec {
    project = var.storage_project

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.minio.metadata[0].name
    }

    source {
      repo_url        = "https://charts.min.io/"
      chart           = "minio"
      target_revision = "5.2.0"

      helm {
        values = templatefile("${path.module}/templates/minio.yml.tpl", {
          username           = var.minio_username
          password           = var.minio_password
          sc_name            = "nfs-jabberwock-subpath"
          size               = "100Gi"
          global_fqdn        = var.global_fqdn
          oidc_config_url    = var.minio_oidc_config_url
          oidc_client_id     = var.minio_oidc_client_id
          oidc_client_secret = var.minio_oidc_client_secret
        })
      }
    }

    sync_policy {
      automated {
        self_heal   = true
        prune       = true
        allow_empty = true
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

module "minio_ingress" {
  source = "../ingress"

  hosts     = ["minio.local"]
  service   = "minio-console"
  namespace = kubernetes_namespace.minio.metadata[0].name
  port      = 9001
}

module "minio_bucket_ingress" {
  source = "../ingress"

  hosts     = ["*.static.zefirsroyal.cloud"]
  service   = "minio"
  namespace = kubernetes_namespace.minio.metadata[0].name
  port      = 9000
}