variable "proxmox_api_token" {
  type        = string
  description = "The Proxmox API token"
}

variable "proxmox_s1_ip" {
  type        = string
  description = "The IP address of the first Proxmox node"
}

variable "argocd_password" {
  type        = string
  description = "ArgoCD admin password"
}

variable "unifi_username" {
  type        = string
  description = "Unifi controller username"
  sensitive   = true
}

variable "unifi_password" {
  type        = string
  description = "Unifi controller password"
  sensitive   = true
}

variable "unifi_api_url" {
  type        = string
  description = "Unifi controller API URL"
  validation {
    condition     = can(regex("https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)", var.unifi_api_url))
    error_message = "unifi_api_url must be a valid URL"
  }
}

variable "unifi_site" {
  type        = string
  description = "Unifi controller site"
}

variable "unifi_wlan_home_password" {
  type        = string
  description = "Password for the home WLAN"
}

variable "unifi_wlan_home_ssid" {
  type        = string
  description = "SSID for the home WLAN"
}

variable "cluster_ipaddr" {
  type        = string
  description = "Cluster's IP address"
}

variable "minio_oidc_config_url" {
  type        = string
  description = "The OIDC config URL for Minio"
}

variable "minio_oidc_client_id" {
  type        = string
  description = "The OIDC client ID for Minio"
}

variable "minio_oidc_client_secret" {
  type        = string
  description = "The OIDC client secret for Minio"
}

variable "authentik_secret_key" {
  type        = string
  description = "Authentik secret key"
}

variable "authentik_postgres_password" {
  type        = string
  description = "Authentik postgres password"
}

variable "global_fqdn" {
  type        = string
  description = "The global FQDN for the homelab"
}

variable "smtp_host" {
  type        = string
  description = "The SMTP host"
}

variable "smtp_port" {
  type        = number
  description = "The SMTP port"
}

variable "smtp_username" {
  type        = string
  description = "The SMTP username"
}

variable "smtp_password" {
  type        = string
  description = "The SMTP password"
}

variable "smtp_from" {
  type        = string
  description = "The SMTP from address"
}

variable "smtp_use_tls" {
  type        = bool
  description = "Whether to use TLS for SMTP"
}

variable "smtp_use_ssl" {
  type        = bool
  description = "Whether to use SSL for SMTP"
}

variable "authentik_token" {
  type        = string
  description = "Authentik token"
}

variable "mqtt_zigbee2mqtt_password_hash" {
  type        = string
  description = "The password hash for the zigbee2mqtt MQTT user"
}

variable "mqtt_homeassistant_password_hash" {
  type        = string
  description = "The password hash for the homeassistant MQTT user"
}

variable "mqtt_octoprint_password_hash" {
  type        = string
  description = "The password hash for the octoprint MQTT user"
}

variable "grist_session_secret" {
  type        = string
  description = "The session secret for Grist"
}

variable "grist_oidc_idp_issuer" {
  type        = string
  description = "The OIDC IDP issuer for Grist"
}

variable "grist_oidc_client_id" {
  type        = string
  description = "The OIDC client ID for Grist"
}

variable "grist_oidc_client_secret" {
  type        = string
  description = "The OIDC client secret for Grist"
}

variable "alertmanager_discord_webhook_url" {
  type        = string
  description = "The Discord webhook URL for Alertmanager"
}

variable "crowdsec_enroll_key" {
  type        = string
  description = "The CrowdSec enrollment key"
}

variable "crowdsec_bouncer_key_traefik" {
  type        = string
  description = "The CrowdSec Traefik bouncer key"
}

variable "letsencrypt_email" {
  type        = string
  description = "The email address to use for Let's Encrypt"
}

variable "letsencrypt_cloudflare_api_token" {
  type        = string
  description = "The Cloudflare API token to use for Let's Encrypt DNS-01 challenges"
}

variable "mqtt_exporter_password_hash" {
  type        = string
  description = "The password hash for the exporter MQTT user"
}

variable "mqtt_exporter_password" {
  type        = string
  description = "The password for the exporter MQTT user"
}

variable "hassio_token" {
  type        = string
  description = "Auth token for Home Assistant"
}

variable "grafana_auth" {
  type        = string
  description = "auth token for grafana"
}

variable "grafana_client_id" {
  type        = string
  description = "The OIDC client ID for Grafana"
}

variable "grafana_client_secret" {
  type        = string
  description = "The OIDC client secret for Grafana"
}

variable "provider_cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for provider"
}

variable "personal_email" {
  type        = string
  description = "The email address of the person deploying the homelab"
}

variable "cloudflare_account_id" {
  type        = string
  description = "The account ID to use in Cloudflare"
}

variable "sonarr_api_key" {
  type        = string
  description = "API key for Sonarr"
}

variable "radarr_api_key" {
  type        = string
  description = "API key for Radarr"
}

variable "lidarr_api_key" {
  type        = string
  description = "API key for Lidarr"
}

variable "bazarr_api_key" {
  type        = string
  description = "API key for Bazarr"
}

variable "prowlarr_api_key" {
  type        = string
  description = "API key for Prowlarr"
}

variable "readarr_api_key" {
  type        = string
  description = "API key for Readarr"
}

variable "plex_token" {
  type        = string
  description = "Plex token"
}

variable "plex_claim" {
  type        = string
  description = "Plex claim"
}

variable "tautulli_api_key" {
  type        = string
  description = "API key for tautulli"
}

variable "qbittorrent_admin_password" {
  type        = string
  description = "Admin password for qBittorrent"
}

variable "linkwarden_nextauth_secret" {
  type        = string
  description = "NextAuth secret for Linkwarden"
}

variable "linkwarden_authentik_client_secret" {
  type        = string
  description = "Authentik client secret for Linkwarden"
}

variable "linkwarden_authentik_client_id" {
  type        = string
  description = "Authentik client ID for Linkwarden"
}

variable "cloudflare_ddns_api_token" {
  type        = string
  description = "The Cloudflare API token for the Cloudflare DDNS service"
}

variable "argocd_oidc_client_id" {
  type        = string
  description = "The OIDC client ID for ArgoCD"
}

variable "argocd_oidc_client_secret" {
  type        = string
  description = "The OIDC client secret for ArgoCD"
}

variable "prowlarr_auth_username" {
  type        = string
  description = "Username for Prowlarr basic authentication"
}

variable "prowlarr_auth_password" {
  type        = string
  description = "Password for Prowlarr basic authentication"
}

variable "prowlarr_discord_webhook_url" {
  type        = string
  description = "Discord webhook URL for Prowlarr"
}

variable "lidarr_auth_username" {
  type        = string
  description = "Username"
}

variable "lidarr_auth_password" {
  type        = string
  description = "Password"
}

variable "lidarr_discord_webhook_url" {
  type        = string
  description = "Discord webhook URL for Lidarr"
}

variable "radarr_auth_username" {
  type        = string
  description = "Username"
}

variable "radarr_auth_password" {
  type        = string
  description = "Password"
}

variable "radarr_discord_webhook_url" {
  type        = string
  description = "Discord webhook URL for Radarr"
}

variable "readarr_discord_webhook_url" {
  type        = string
  description = "Discord webhook URL for Readarr"
}

variable "sonarr_auth_username" {
  type        = string
  description = "Username"
}

variable "sonarr_auth_password" {
  type        = string
  description = "Password"
}

variable "sonarr_discord_webhook_url" {
  type        = string
  description = "Discord webhook URL for Sonarr"
}

variable "nocodb_oidc_client_id" {
  type        = string
  description = "OIDC client ID for NocoDB"
}

variable "nocodb_oidc_client_secret" {
  type        = string
  description = "OIDC client secret for NocoDB"
}

variable "nocodb_auth_secret" {
  type        = string
  description = "Auth secret for NocoDB"
}

variable "rally_client_id" {
  type        = string
  description = "Client ID for Rally"
}

variable "rally_client_secret" {
  type        = string
  description = "Client secret for Rally"
}

variable "rally_secret_password" {
  type        = string
  description = "Secret password for Rally"
}

variable "manyfold_secret_key_base" {
  type        = string
  description = "Secret key base for Manyfold"
}

variable "nextcloud_s3_access_key" {
  type        = string
  description = "nextcloud s3 access key"
}

variable "nextcloud_s3_secret_key" {
  type        = string
  description = "nextcloud s3 secret key"
}

variable "paperless_secret_key" {
  type        = string
  description = "Paperless secret key"
}

variable "paperless_oidc_client_id" {
  type        = string
  description = "OIDC client ID for Paperless"
}

variable "paperless_oidc_client_secret" {
  type        = string
  description = "OIDC client secret for Paperless"
}

variable "jellyseerr_api_key" {
  type        = string
  description = "API key for Jellyseerr"
}

variable "netbox_superuser_email" {
  type        = string
  description = "Netbox superuser email"
}

variable "netbox_superuser_name" {
  type        = string
  description = "Netbox superuser name"
}

variable "netbox_superuser_password" {
  type        = string
  description = "Netbox superuser password"
}

variable "netbox_aws_access_key_id" {
  type        = string
  description = "Netbox AWS access key ID"
}

variable "netbox_aws_secret_access_key" {
  type        = string
  description = "Netbox AWS secret"
}

variable "outline_oidc_client_id" {
  type        = string
  description = "OIDC client ID for Outline"
}

variable "outline_oidc_client_secret" {
  type        = string
  description = "OIDC client secret for Outline"
}

variable "outline_secret_key" {
  type        = string
  description = "Secret key for Outline"
}

variable "outline_utils_secret" {
  type        = string
  description = "Utils secret for Outline"
}

variable "outline_aws_access_key_id" {
  type        = string
  description = "AWS access key ID for Outline"
}

variable "outline_aws_secret_access_key" {
  type        = string
  description = "AWS secret access key for Outline"
}

variable "netbox_oidc_client_id" {
  type        = string
  description = "OIDC client ID for Netbox"
}

variable "netbox_oidc_client_secret" {
  type        = string
  description = "OIDC client secret for Netbox"
}