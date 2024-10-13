resource "kubernetes_secret" "prowlarr_exporter_secret" {
  metadata {
    name      = "prowlarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.prowlarr_api_key
  }
}

resource "argocd_application" "prowlarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.prowlarr_exporter_secret]

  metadata {
    name      = "prowlarr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/entertainment/prowlarr"
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

module "prowlarr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.prowlarr]

  service   = "prowlarr"
  hosts     = ["prowlarr.local"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 9696
}