resource "kubernetes_secret" "plex_secrets" {
  metadata {
    name      = "plex-secrets"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }

  data = {
    "api-key" = var.plex_token
    "claim"   = var.plex_claim
  }
}

resource "argocd_application" "plex" {
  depends_on = [kubernetes_namespace.entertainment, kubernetes_secret.plex_secrets]

  metadata {
    name      = "plex"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.entertainment.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/plex"
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

module "plex_ingress" {
  depends_on = [argocd_application.plex]
  source     = "../ingress"

  service   = "plex"
  namespace = "entertainment"
  port      = 32400

  hosts = ["birds.${var.global_fqdn}"]
}