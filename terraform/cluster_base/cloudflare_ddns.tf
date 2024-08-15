resource "kubernetes_namespace" "cloudflare_ddns" {
  metadata {
    name = "cloudflare-ddns"
  }
}

resource "kubernetes_config_map" "cloudflare_ddns" {
  metadata {
    name      = "cloudflare-ddns-config"
    namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
  }

  data = {
    domains = ""
    proxied = ""
  }
}

resource "kubernetes_secret" "cloudflare_ddns" {
  metadata {
    name      = "cloudflare-ddns-secrets"
    namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
  }

  data = {
    "api-token" = ""
  }
}

resource "argocd_application" "cloudflare_ddns" {
  depends_on = [ kubernetes_secret.cloudflare_ddns, kubernetes_config_map.cloudflare_ddns ]

  metadata {
    name      = "cloudflare-ddns"
    namespace = "argocd"
  }

  wait = true

  spec {
    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/cloudflare-ddns"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
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