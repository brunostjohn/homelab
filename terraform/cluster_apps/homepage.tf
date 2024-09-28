resource "kubernetes_namespace" "homepage" {
  metadata {
    name = "homepage"
  }
}

resource "kubernetes_config_map" "homepage" {
  metadata {
    name      = "homepage-config"
    namespace = kubernetes_namespace.homepage.metadata[0].name
  }

  data = {
    "HOMEPAGE_VAR_GLOBAL_FQDN"    = var.global_fqdn
    "HOMEPAGE_VAR_UNIFI_USERNAME" = var.unifi_username
  }
}

resource "kubernetes_secret" "homepage" {
  metadata {
    name      = "homepage-secrets"
    namespace = kubernetes_namespace.homepage.metadata[0].name
  }

  data = {
    "HOMEPAGE_VAR_UNIFI_PASSWORD"       = var.unifi_password
    "HOMEPAGE_VAR_JABBERWOCK_API_KEY"   = var.jabberwock_api_key
    "HOMEPAGE_VAR_LOOKINGGLASS_API_KEY" = var.lookingglass_api_key
    "HOMEPAGE_VAR_FLOOF_API_KEY"        = var.floof_api_key
    "HOMEPAGE_VAR_JELLYFIN_API_KEY"     = var.jellyfin_api_key
    "HOMEPAGE_VAR_JELLYSEERR_API_KEY"   = var.jellyseerr_api_key
  }
}

resource "argocd_application" "homepage" {
  depends_on = [kubernetes_namespace.homepage, kubernetes_config_map.homepage, kubernetes_secret.homepage]

  metadata {
    name      = "homepage"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/homepage"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.homepage.metadata[0].name
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