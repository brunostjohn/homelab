resource "kubernetes_namespace" "entertainment" {
  metadata {
    name = "entertainment"
  }
}

resource "kubernetes_secret" "sonarr_exporter_secret" {
  metadata {
    name      = "sonarr-exporter"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.sonarr_api_key
  }
}

resource "argocd_application" "sonarr" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.sonarr_exporter_secret]

  metadata {
    name      = "sonarr"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/sonarr"
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

module "sonarr_ingress" {
  source     = "../ingress"
  depends_on = [argocd_application.sonarr]

  service   = "sonarr"
  hosts     = ["sonarr.local"]
  namespace = kubernetes_namespace.entertainment.metadata[0].name
  port      = 8989
}