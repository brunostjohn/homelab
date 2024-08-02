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
          username = var.minio_username,
          password = var.minio_password
          sc_name  = "nfs-jabberwock-subpath"
          size     = "100Gi"
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
  source = "./ingress"

  hosts     = ["minio.local", "static.${var.global_fqdn}"]
  service   = "minio-console"
  namespace = kubernetes_namespace.minio.metadata[0].name
  port      = 9001
}