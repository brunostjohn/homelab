module "cluster_base" {
  source = "./cluster_base"

  global_fqdn = var.global_fqdn
  second_fqdn = var.second_fqdn

  smtp_host     = var.smtp_host
  smtp_port     = var.smtp_port
  smtp_from     = var.smtp_from
  smtp_username = var.smtp_username
  smtp_password = var.smtp_password
  smtp_use_ssl  = var.smtp_use_ssl
  smtp_use_tls  = var.smtp_use_tls

  alertmanager_discord_webhook_url = var.alertmanager_discord_webhook_url
  crowdsec_enroll_key              = var.crowdsec_enroll_key
  crowdsec_bouncer_key_traefik     = var.crowdsec_bouncer_key_traefik
  letsencrypt_email                = var.letsencrypt_email
  letsencrypt_cloudflare_api_token = var.letsencrypt_cloudflare_api_token
  cluster_loadbalancer_ip          = var.cluster_ipaddr
  cloudflare_ddns_api_token        = var.cloudflare_ddns_api_token
  argocd_oidc_client_id            = var.argocd_oidc_client_id
  argocd_oidc_client_secret        = var.argocd_oidc_client_secret
  proxmox_api_token                = var.proxmox_api_token
  personal_email                   = var.personal_email
  floof_api_key                    = var.floof_api_key
  klaudia_email                    = var.klaudia_email

  pgadmin_username           = var.pgadmin_username
  pgadmin_password           = var.pgadmin_password
  pg_superuser_password      = var.pg_superuser_password
  pg_backup_minio_access_key = var.pg_backup_minio_access_key
  pg_backup_minio_secret_key = var.pg_backup_minio_secret_key

  jabberwock_api_key = var.jabberwock_api_key

  crowdsec_db_password = var.crowdsec_db_password
  crowdsec_webhook_url = var.crowdsec_webhook_url

  grafana_db_password = var.grafana_db_password

  infisical_auth_secret          = var.infisical_auth_secret
  infisical_encryption_key       = var.infisical_encryption_key
  infisical_db_password          = var.infisical_db_password
  infisical_google_client_id     = var.infisical_google_client_id
  infisical_google_client_secret = var.infisical_google_client_secret
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.cluster_base]

  second_fqdn                      = var.second_fqdn
  networking_project               = module.cluster_base.networking_project
  security_project                 = module.cluster_base.security_project
  storage_project                  = module.cluster_base.storage_project
  homelab_repo                     = module.cluster_base.homelab_repo
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

  linkwarden_authentik_client_id     = var.linkwarden_authentik_client_id
  linkwarden_authentik_client_secret = var.linkwarden_authentik_client_secret
  linkwarden_nextauth_secret         = var.linkwarden_nextauth_secret

  nocodb_oidc_client_id     = var.nocodb_oidc_client_id
  nocodb_oidc_client_secret = var.nocodb_oidc_client_secret
  nocodb_auth_secret        = var.nocodb_auth_secret

  rally_client_id       = var.rally_client_id
  rally_client_secret   = var.rally_client_secret
  rally_secret_password = var.rally_secret_password

  manyfold_secret_key_base = var.manyfold_secret_key_base

  nextcloud_s3_access_key = var.nextcloud_s3_access_key
  nextcloud_s3_secret_key = var.nextcloud_s3_secret_key

  paperless_secret_key         = var.paperless_secret_key
  paperless_oidc_client_id     = var.paperless_oidc_client_id
  paperless_oidc_client_secret = var.paperless_oidc_client_secret

  jellyseerr_api_key = var.jellyseerr_api_key

  netbox_superuser_email       = var.netbox_superuser_email
  netbox_superuser_name        = var.netbox_superuser_name
  netbox_superuser_password    = var.netbox_superuser_password
  netbox_aws_access_key_id     = var.netbox_aws_access_key_id
  netbox_aws_secret_access_key = var.netbox_aws_secret_access_key
  netbox_oidc_client_id        = var.netbox_oidc_client_id
  netbox_oidc_client_secret    = var.netbox_oidc_client_secret

  outline_aws_access_key_id     = var.outline_aws_access_key_id
  outline_aws_secret_access_key = var.outline_aws_secret_access_key
  outline_oidc_client_secret    = var.outline_oidc_client_secret
  outline_secret_key            = var.outline_secret_key
  outline_utils_secret          = var.outline_utils_secret
  outline_oidc_client_id        = var.outline_oidc_client_id

  romm_auth_secret_key     = var.romm_auth_secret_key
  romm_igdb_client_id      = var.romm_igdb_client_id
  romm_igdb_client_secret  = var.romm_igdb_client_secret
  romm_mobygames_api_key   = var.romm_mobygames_api_key
  romm_steamgriddb_api_key = var.romm_steamgriddb_api_key

  mealie_oidc_client_id = var.mealie_oidc_client_id

  ollama_oidc_client_id       = var.ollama_oidc_client_id
  ollama_oidc_client_secret   = var.ollama_oidc_client_secret
  ollama_google_pse_api_key   = var.ollama_google_pse_api_key
  ollama_google_pse_engine_id = var.ollama_google_pse_engine_id

  immich_db_password      = var.immich_db_password
  blocky_db_password      = var.blocky_db_password
  netbox_db_password      = var.netbox_db_password
  paperless_db_password   = var.paperless_db_password
  linkwarden_db_password  = var.linkwarden_db_password
  nextcloud_db_password   = var.nextcloud_db_password
  manyfold_db_password    = var.manyfold_db_password
  mealie_db_password      = var.mealie_db_password
  jellyseerr_db_password  = var.jellyseerr_db_password
  windmill_db_password    = var.windmill_db_password
  rally_db_password       = var.rally_db_password
  outline_db_password     = var.outline_db_password
  memos_db_password       = var.memos_db_password
  vaultwarden_db_password = var.vaultwarden_db_password
  coder_db_password       = var.coder_db_password
  nocodb_db_password      = var.nocodb_db_password
  oneuptime_db_password   = var.oneuptime_db_password
  zipline_db_password     = var.zipline_db_password

  vaultwarden_installation_id  = var.vaultwarden_installation_id
  vaultwarden_installation_key = var.vaultwarden_installation_key

  opengist_oidc_client_id     = var.opengist_oidc_client_id
  opengist_oidc_client_secret = var.opengist_oidc_client_secret

  coder_oidc_client_id     = var.coder_oidc_client_id
  coder_oidc_client_secret = var.coder_oidc_client_secret

  stirling_pdf_oidc_client_id     = var.stirling_pdf_oidc_client_id
  stirling_pdf_oidc_client_secret = var.stirling_pdf_oidc_client_secret

  jabberwock_api_key   = var.jabberwock_api_key
  lookingglass_api_key = var.lookingglass_api_key
  floof_api_key        = var.floof_api_key

  jellyfin_api_key = var.jellyfin_api_key

  nocodb_admin_email      = var.nocodb_admin_email
  nocodb_s3_access_key    = var.nocodb_s3_access_key
  nocodb_s3_access_secret = var.nocodb_s3_access_secret

  plane_aws_access_key_id     = var.plane_aws_access_key_id
  plane_aws_secret_access_key = var.plane_aws_secret_access_key
  plane_db_password           = var.plane_db_password
  plane_secret_key            = var.plane_secret_key

  nextcloud_api_key        = var.nextcloud_api_key
  romm_username            = var.romm_username
  romm_password            = var.romm_password
  proxmox_api_token_id     = var.proxmox_api_token_id
  proxmox_api_token_secret = var.proxmox_api_token_secret
  authentik_api_key        = var.authentik_api_key
  immich_api_key           = var.immich_api_key
  homeassistant_api_key    = var.homeassistant_api_key
  mealie_api_key           = var.mealie_api_key
  paperless_api_key        = var.paperless_api_key
  linkwarden_api_key       = var.linkwarden_api_key
  grafana_username         = var.grafana_username
  grafana_password         = var.grafana_password
  qbittorrent_username     = var.qbittorrent_username
  qbittorrent_password     = var.qbittorrent_password
  audiobookshelf_api_key   = var.audiobookshelf_api_key

  zipline_core_secret        = var.zipline_core_secret
  zipline_oidc_client_id     = var.zipline_oidc_client_id
  zipline_oidc_client_secret = var.zipline_oidc_client_secret

  sabnzbd_api_key   = var.sabnzbd_api_key
  openwebui_api_key = var.openwebui_api_key
}

module "grafana" {
  source = "./grafana"

  global_fqdn    = var.global_fqdn
  client_id      = var.grafana_client_id
  client_secret  = var.grafana_client_secret
  personal_email = var.personal_email
  klaudia_email  = var.klaudia_email
}