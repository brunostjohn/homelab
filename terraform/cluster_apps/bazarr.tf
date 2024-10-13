resource "kubernetes_secret" "bazarr_exporter_secret" {
  metadata {
    name      = "bazarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.bazarr_api_key
  }
}

resource "argocd_application" "bazarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.bazarr_exporter_secret]

  metadata {
    name      = "bazarr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/entertainment/bazarr"
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

module "bazarr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.bazarr]

  service   = "bazarr"
  hosts     = ["bazarr.local"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 6767
}