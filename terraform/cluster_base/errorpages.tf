resource "kubernetes_config_map" "errorpages" {
  metadata {
    name = "errorpages-config"
    namespace = "kube-system"
  }

  data = {
    "PUBLIC_STATIC_URL" = "https://homepage-assets.static.${var.global_fqdn}"
    "PUBLIC_HOMEPAGE_URL" = "https://${var.global_fqdn}"
  }
}

resource "argocd_application" "errorpages" {
  depends_on = [kubernetes_config_map.errorpages]

  metadata {
    name      = "errorpages"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.cluster_mgmt.metadata[0].name

    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/errorpages"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-system"
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