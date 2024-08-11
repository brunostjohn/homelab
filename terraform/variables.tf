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

variable "adguard_host" {
  type        = string
  description = "AdGuard host"
}

variable "adguard_username" {
  type        = string
  description = "AdGuard username"
}

variable "adguard_password" {
  type        = string
  description = "AdGuard password"
}

variable "adguard_scheme" {
  type        = string
  description = "HTTP or HTTPS"
}

variable "cluster_ipaddr" {
  type        = string
  description = "Cluster's IP address"
}

variable "k8s_dashboard_token" {
  type        = string
  description = "The token for the k8s dashboard"
}

variable "minio_username" {
  type        = string
  description = "Minio username"
}

variable "minio_password" {
  type        = string
  description = "Minio password"
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