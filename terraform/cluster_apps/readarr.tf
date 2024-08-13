resource "kubernetes_secret" "readarr_exporter_secret" {
  metadata {
    name      = "readarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.readarr_api_key
  }
}

resource "argocd_application" "readarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.readarr_exporter_secret]

  metadata {
    name      = "readarr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/readarr"
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

module "readarr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.readarr]

  service   = "readarr"
  hosts     = ["readarr.local"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 8787
}