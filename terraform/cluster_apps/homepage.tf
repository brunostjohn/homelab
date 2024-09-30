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
    "HOMEPAGE_VAR_GLOBAL_FQDN"          = var.global_fqdn
    "HOMEPAGE_VAR_UNIFI_USERNAME"       = var.unifi_username
    "HOMEPAGE_VAR_ROMM_USERNAME"        = var.romm_username
    "HOMEPAGE_VAR_QBITTORRENT_USERNAME" = var.qbittorrent_username
    "HOMEPAGE_VAR_GRAFANA_USERNAME"     = var.grafana_username
    "HOMEPAGE_VAR_PROXMOX_API_TOKEN_ID" = var.proxmox_api_token_id
  }
}

resource "kubernetes_secret" "homepage" {
  metadata {
    name      = "homepage-secrets"
    namespace = kubernetes_namespace.homepage.metadata[0].name
  }

  data = {
    "HOMEPAGE_VAR_UNIFI_PASSWORD"           = var.unifi_password
    "HOMEPAGE_VAR_JABBERWOCK_API_KEY"       = var.jabberwock_api_key
    "HOMEPAGE_VAR_LOOKINGGLASS_API_KEY"     = var.lookingglass_api_key
    "HOMEPAGE_VAR_FLOOF_API_KEY"            = var.floof_api_key
    "HOMEPAGE_VAR_JELLYFIN_API_KEY"         = var.jellyfin_api_key
    "HOMEPAGE_VAR_JELLYSEERR_API_KEY"       = var.jellyseerr_api_key
    "HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY"   = var.audiobookshelf_api_key
    "HOMEPAGE_VAR_ROMM_PASSWORD"            = var.romm_password
    "HOMEPAGE_VAR_AUTHENTIK_API_KEY"        = var.authentik_api_key
    "HOMEPAGE_VAR_IMMICH_API_KEY"           = var.immich_api_key
    "HOMEPAGE_VAR_NEXTCLOUD_API_KEY"        = var.nextcloud_api_key
    "HOMEPAGE_VAR_HOMEASSISTANT_API_KEY"    = var.homeassistant_api_key
    "HOMEPAGE_VAR_MEALIE_API_KEY"           = var.mealie_api_key
    "HOMEPAGE_VAR_PAPERLESS_API_KEY"        = var.paperless_api_key
    "HOMEPAGE_VAR_LINKWARDEN_API_KEY"       = var.linkwarden_api_key
    "HOMEPAGE_VAR_QBITTORRENT_PASSWORD"     = var.qbittorrent_password
    "HOMEPAGE_VAR_PROWLARR_API_KEY"         = var.prowlarr_api_key
    "HOMEPAGE_VAR_RADARR_API_KEY"           = var.radarr_api_key
    "HOMEPAGE_VAR_SONARR_API_KEY"           = var.sonarr_api_key
    "HOMEPAGE_VAR_BAZARR_API_KEY"           = var.bazarr_api_key
    "HOMEPAGE_VAR_LIDARR_API_KEY"           = var.lidarr_api_key
    "HOMEPAGE_VAR_READARR_API_KEY"          = var.readarr_api_key
    "HOMEPAGE_VAR_GRAFANA_PASSWORD"         = var.grafana_password
    "HOMEPAGE_VAR_PROXMOX_API_TOKEN_SECRET" = var.proxmox_api_token_secret
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