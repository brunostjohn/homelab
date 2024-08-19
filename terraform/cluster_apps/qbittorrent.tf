resource "kubernetes_secret" "qbittorrent_exporter_secret" {
  metadata {
    name      = "qbittorrent"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "password" = var.qbittorrent_admin_password
  }
}

resource "argocd_application" "qbittorrent" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.qbittorrent_exporter_secret]

  metadata {
    name      = "qbittorrent"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/qbittorrent"
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

module "qbittorrent_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.qbittorrent]

  service   = "qbittorrent"
  hosts     = ["qbittorrent.local"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 8080
}