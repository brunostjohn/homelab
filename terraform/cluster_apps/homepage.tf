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
    "PUBLIC_DOMAIN"        = var.global_fqdn
    "JELLYFIN_URL"         = "http://jellyfin.entertainment.svc.cluster.local:8096"
    "UNIFI_URL"            = "https://10.0.0.1"
    "UNIFI_USERNAME"       = var.unifi_username
    "TRUENAS_FLOOF"        = "http://10.0.3.5"
    "TRUENAS_JABBERWOCK"   = "http://10.0.3.1"
    "TRUENAS_LOOKINGGLASS" = "http://10.0.3.2"
    "JELLYSEERR_BASE_URL"  = "http://jellyseerr.entertainment.svc.cluster.local:5000"
    "QBITTORRENT_URL"      = "http://qbittorrent.entertainment.svc.cluster.local:8080"
    "QBITTORRENT_USERNAME" = var.qbittorrent_username
    "SABNZBD_URL"          = "http://sabnzbd.entertainment.svc.cluster.local:8080"
  }
}

resource "kubernetes_secret" "homepage" {
  metadata {
    name      = "homepage-secrets"
    namespace = kubernetes_namespace.homepage.metadata[0].name
  }

  data = {
    "JELLYFIN_TOKEN"               = var.jellyfin_api_key
    "UNIFI_PASSWORD"               = var.unifi_password
    "TRUENAS_FLOOF_API_KEY"        = var.floof_api_key
    "TRUENAS_JABBERWOCK_API_KEY"   = var.jabberwock_api_key
    "TRUENAS_LOOKINGGLASS_API_KEY" = var.lookingglass_api_key
    "JELLYSEERR_API_KEY"           = var.jellyseerr_api_key
    "QBITTORRENT_PASSWORD"         = var.qbittorrent_password
    "SABNZBD_API_KEY"              = var.sabnzbd_api_key
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