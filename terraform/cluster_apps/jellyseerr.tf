resource "kubernetes_secret" "jellyseerr_exporter_secret" {
  metadata {
    name      = "jellyseerr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.jellyseerr_api_key
  }
}

resource "argocd_application" "jellyseerr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.jellyseerr_exporter_secret]

  metadata {
    name      = "jellyseerr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/jellyseerr"
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

module "jellyseerr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.qbittorrent]

  service   = "jellyseerr"
  hosts     = ["js.${var.global_fqdn}"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 5055
}