module "nextcloud_helm" {
  source = "../helm_deployment"

  name             = "nextcloud"
  namespace        = "nextcloud"
  create_namespace = true

  repo_url        = "https://nextcloud.github.io/helm/"
  chart           = "nextcloud"
  target_revision = "6.0.3"

  values = templatefile("${path.module}/templates/nextcloud.yml.tpl", {
    global_fqdn   = var.global_fqdn
    smtp_host     = var.smtp_host
    smtp_port     = var.smtp_port
    smtp_username = var.smtp_username
    smtp_password = var.smtp_password
    s3_access_key = var.nextcloud_s3_access_key
    s3_secret_key = var.nextcloud_s3_secret_key
    s3_host       = "minio-svc.minio.svc.cluster.local"
    db_password   = var.nextcloud_db_password
  })

  create_ingress = false
}

resource "argocd_application" "imaginary" {
  depends_on = [module.nextcloud_helm]

  metadata {
    name      = "imaginary"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/productivity/imaginary"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "nextcloud"
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