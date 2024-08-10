resource "kubernetes_namespace" "nfs_provisioner" {
  metadata {
    name = "nfs-provisioner"
  }
}

resource "argocd_application" "nfs_provisioner" {
  depends_on = [helm_release.argocd, kubernetes_ingress_v1.argocd_ingress]

  metadata {
    name      = "nfs-provisioner"
    namespace = "argocd"
  }

  wait = true

  spec {
    project = argocd_project.storage.metadata[0].name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.nfs_provisioner.metadata[0].name
    }

    source {
      repo_url        = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner"
      chart           = "nfs-subdir-external-provisioner"
      target_revision = "4.0.18"

      helm {
        values = var.nfs_provisioner_values
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