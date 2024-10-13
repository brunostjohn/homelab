resource "argocd_application" "jellyfin" {
  depends_on = [kubernetes_namespace.entertainment]

  metadata {
    name      = "jellyfin"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/entertainment/jellyfin"
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

module "jellyfin_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.lidarr]

  service   = "jellyfin"
  hosts     = ["birds.${var.global_fqdn}"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 8096
}