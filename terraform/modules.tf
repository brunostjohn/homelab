module "unifi" {
  source             = "./unifi"
  wlan_home_password = var.unifi_wlan_home_password
  wlan_home_ssid     = var.unifi_wlan_home_ssid
  cluster_ip         = var.cluster_ipaddr
}

module "cloudflare" {
  depends_on = [module.unifi]

  global_fqdn = var.global_fqdn
  account_id  = var.cloudflare_account_id

  source = "./cloudflare"
}

module "cluster_base" {
  source     = "./cluster_base"
  depends_on = [module.unifi]

  global_fqdn                      = var.global_fqdn
  alertmanager_discord_webhook_url = var.alertmanager_discord_webhook_url
  crowdsec_enroll_key              = var.crowdsec_enroll_key
  crowdsec_bouncer_key_traefik     = var.crowdsec_bouncer_key_traefik
  letsencrypt_email                = var.letsencrypt_email
  letsencrypt_cloudflare_api_token = var.letsencrypt_cloudflare_api_token
  cluster_loadbalancer_ip          = var.cluster_ipaddr
  cloudflare_ddns_api_token        = var.cloudflare_ddns_api_token
  argocd_oidc_client_id            = var.argocd_oidc_client_id
  argocd_oidc_client_secret        = var.argocd_oidc_client_secret
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.unifi, module.cluster_base, module.cloudflare]

  networking_project               = module.cluster_base.networking_project
  security_project                 = module.cluster_base.security_project
  storage_project                  = module.cluster_base.storage_project
  homelab_repo                     = module.cluster_base.homelab_repo
  adguard_username                 = var.adguard_username
  adguard_password                 = var.adguard_password
  minio_username                   = var.minio_username
  minio_password                   = var.minio_password
  minio_oidc_client_id             = var.minio_oidc_client_id
  minio_oidc_client_secret         = var.minio_oidc_client_secret
  minio_oidc_config_url            = var.minio_oidc_config_url
  authentik_postgres_password      = var.authentik_postgres_password
  authentik_secret_key             = var.authentik_secret_key
  global_fqdn                      = var.global_fqdn
  smtp_host                        = var.smtp_host
  smtp_port                        = var.smtp_port
  smtp_from                        = var.smtp_from
  smtp_username                    = var.smtp_username
  smtp_password                    = var.smtp_password
  smtp_use_ssl                     = var.smtp_use_ssl
  smtp_use_tls                     = var.smtp_use_tls
  mqtt_homeassistant_password_hash = var.mqtt_homeassistant_password_hash
  mqtt_zigbee2mqtt_password_hash   = var.mqtt_zigbee2mqtt_password_hash
  mqtt_octoprint_password_hash     = var.mqtt_octoprint_password_hash
  grist_session_secret             = var.grist_session_secret
  grist_oidc_client_id             = var.grist_oidc_client_id
  grist_oidc_client_secret         = var.grist_oidc_client_secret
  grist_oidc_idp_issuer            = var.grist_oidc_idp_issuer
  mqtt_exporter_password_hash      = var.mqtt_exporter_password_hash
  mqtt_exporter_password           = var.mqtt_exporter_password
  hassio_token                     = var.hassio_token
  unifi_username                   = var.unifi_username
  unifi_password                   = var.unifi_password

  sonarr_api_key             = var.sonarr_api_key
  radarr_api_key             = var.radarr_api_key
  lidarr_api_key             = var.lidarr_api_key
  bazarr_api_key             = var.bazarr_api_key
  prowlarr_api_key           = var.prowlarr_api_key
  readarr_api_key            = var.readarr_api_key
  plex_token                 = var.plex_token
  plex_claim                 = var.plex_claim
  tautulli_api_key           = var.tautulli_api_key
  qbittorrent_admin_password = var.qbittorrent_admin_password
  overseerr_api_key          = var.overseerr_api_key

  linkwarden_authentik_client_id     = var.linkwarden_authentik_client_id
  linkwarden_authentik_client_secret = var.linkwarden_authentik_client_secret
  linkwarden_nextauth_secret         = var.linkwarden_nextauth_secret
}

module "adguard" {
  source     = "./adguard"
  depends_on = [module.unifi, module.cluster_apps]

  meowbox_ipaddr  = module.unifi.meowbox_ipaddr
  cluster_ipaddr  = var.cluster_ipaddr
  node1_pi_ipaddr = module.unifi.node1_pi_ipaddr
  node2_pi_ipaddr = module.unifi.node2_pi_ipaddr
  node3_pi_ipaddr = module.unifi.node3_pi_ipaddr
  global_fqdn     = var.global_fqdn
}

module "authentik" {
  source     = "./authentik"
  depends_on = [module.unifi, module.cluster_apps]
}

module "grafana" {
  source     = "./grafana"
  depends_on = [module.unifi, module.cluster_apps, module.authentik]

  global_fqdn    = var.global_fqdn
  client_id      = var.grafana_client_id
  client_secret  = var.grafana_client_secret
  personal_email = var.personal_email
}

module "prowlarr" {
  depends_on = [module.authentik, module.cluster_apps]
  source     = "./prowlarr"

  sonarr_api_key             = var.sonarr_api_key
  radarr_api_key             = var.radarr_api_key
  lidarr_api_key             = var.lidarr_api_key
  readarr_api_key            = var.readarr_api_key
  qbittorrent_admin_password = var.qbittorrent_admin_password
  auth_username              = var.prowlarr_auth_username
  auth_password              = var.prowlarr_auth_password
  discord_webhook_url        = var.prowlarr_discord_webhook_url
}

module "lidarr" {
  depends_on = [module.authentik, module.cluster_apps]
  source     = "./lidarr"

  qbittorrent_password = var.qbittorrent_admin_password
  auth_username        = var.lidarr_auth_username
  auth_password        = var.lidarr_auth_password
  discord_webhook_url  = var.lidarr_discord_webhook_url
}

module "radarr" {
  depends_on = [module.authentik, module.cluster_apps]
  source     = "./radarr"

  qbittorrent_password = var.qbittorrent_admin_password
  discord_webhook_url  = var.radarr_discord_webhook_url
  auth_username        = var.radarr_auth_username
  auth_password        = var.radarr_auth_password
}

module "sonarr" {
  depends_on = [module.authentik, module.cluster_apps]
  source     = "./sonarr"

  qbittorrent_password = var.qbittorrent_admin_password
  discord_webhook_url  = var.sonarr_discord_webhook_url
  auth_username        = var.sonarr_auth_username
  auth_password        = var.sonarr_auth_password
}

module "readarr" {
  depends_on = [module.authentik, module.cluster_apps]
  source     = "./readarr"

  qbittorrent_password = var.qbittorrent_admin_password
  discord_webhook_url  = var.readarr_discord_webhook_url
}
