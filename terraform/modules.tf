module "cluster_base" {
  source = "./cluster_base"

  global_fqdn = nonsensitive(data.infisical_secrets.cluster.secrets["global_fqdn"].value)
  second_fqdn = nonsensitive(data.infisical_secrets.cluster.secrets["second_fqdn"].value)

  smtp_host     = data.infisical_secrets.cluster.secrets["smtp_host"].value
  smtp_port     = data.infisical_secrets.cluster.secrets["smtp_port"].value
  smtp_from     = data.infisical_secrets.cluster.secrets["smtp_from"].value
  smtp_username = data.infisical_secrets.cluster.secrets["smtp_username"].value
  smtp_password = data.infisical_secrets.cluster.secrets["smtp_password"].value
  smtp_use_ssl  = data.infisical_secrets.cluster.secrets["smtp_use_ssl"].value
  smtp_use_tls  = data.infisical_secrets.cluster.secrets["smtp_use_tls"].value

  alertmanager_discord_webhook_url = data.infisical_secrets.cluster.secrets["alertmanager_discord_webhook_url"].value
  crowdsec_enroll_key              = data.infisical_secrets.cluster.secrets["crowdsec_enroll_key"].value
  crowdsec_bouncer_key_traefik     = data.infisical_secrets.cluster.secrets["crowdsec_bouncer_key_traefik"].value
  letsencrypt_email                = data.infisical_secrets.cluster.secrets["letsencrypt_email"].value
  letsencrypt_cloudflare_api_token = data.infisical_secrets.cluster.secrets["letsencrypt_cloudflare_api_token"].value
  cluster_loadbalancer_ip          = data.infisical_secrets.cluster.secrets["CLUSTER_LOADBALANCER_IP"].value
  cloudflare_ddns_api_token        = data.infisical_secrets.cluster.secrets["cloudflare_ddns_api_token"].value
  argocd_oidc_client_id            = data.infisical_secrets.cluster.secrets["argocd_oidc_client_id"].value
  argocd_oidc_client_secret        = data.infisical_secrets.cluster.secrets["argocd_oidc_client_secret"].value
  proxmox_api_token                = data.infisical_secrets.cluster.secrets["proxmox_api_token"].value
  personal_email                   = data.infisical_secrets.cluster.secrets["personal_email"].value
  floof_api_key                    = data.infisical_secrets.cluster.secrets["floof_api_key"].value
  klaudia_email                    = data.infisical_secrets.cluster.secrets["klaudia_email"].value

  pgadmin_username           = data.infisical_secrets.cluster.secrets["pgadmin_username"].value
  pgadmin_password           = data.infisical_secrets.cluster.secrets["pgadmin_password"].value
  pg_superuser_password      = data.infisical_secrets.cluster.secrets["pg_superuser_password"].value
  pg_backup_minio_access_key = data.infisical_secrets.cluster.secrets["pg_backup_minio_access_key"].value
  pg_backup_minio_secret_key = data.infisical_secrets.cluster.secrets["pg_backup_minio_secret_key"].value

  jabberwock_api_key = data.infisical_secrets.cluster.secrets["jabberwock_api_key"].value

  crowdsec_db_password = data.infisical_secrets.cluster.secrets["crowdsec_db_password"].value
  crowdsec_webhook_url = data.infisical_secrets.cluster.secrets["crowdsec_webhook_url"].value

  grafana_db_password = data.infisical_secrets.cluster.secrets["grafana_db_password"].value

  infisical_auth_secret          = data.infisical_secrets.cluster.secrets["infisical_auth_secret"].value
  infisical_encryption_key       = data.infisical_secrets.cluster.secrets["infisical_encryption_key"].value
  infisical_db_password          = data.infisical_secrets.cluster.secrets["infisical_db_password"].value
  infisical_google_client_id     = data.infisical_secrets.cluster.secrets["infisical_google_client_id"].value
  infisical_google_client_secret = data.infisical_secrets.cluster.secrets["infisical_google_client_secret"].value
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.cluster_base]

  second_fqdn                      = nonsensitive(data.infisical_secrets.cluster.secrets["second_fqdn"].value)
  networking_project               = module.cluster_base.networking_project
  security_project                 = module.cluster_base.security_project
  storage_project                  = module.cluster_base.storage_project
  homelab_repo                     = module.cluster_base.homelab_repo
  global_fqdn                      = nonsensitive(data.infisical_secrets.cluster.secrets["global_fqdn"].value)
  minio_oidc_client_id             = data.infisical_secrets.cluster.secrets["minio_oidc_client_id"].value
  minio_oidc_client_secret         = data.infisical_secrets.cluster.secrets["minio_oidc_client_secret"].value
  minio_oidc_config_url            = data.infisical_secrets.cluster.secrets["minio_oidc_config_url"].value
  authentik_postgres_password      = data.infisical_secrets.cluster.secrets["authentik_postgres_password"].value
  authentik_secret_key             = data.infisical_secrets.cluster.secrets["authentik_secret_key"].value
  smtp_host                        = data.infisical_secrets.cluster.secrets["smtp_host"].value
  smtp_port                        = data.infisical_secrets.cluster.secrets["smtp_port"].value
  smtp_from                        = data.infisical_secrets.cluster.secrets["smtp_from"].value
  smtp_username                    = data.infisical_secrets.cluster.secrets["smtp_username"].value
  smtp_password                    = data.infisical_secrets.cluster.secrets["smtp_password"].value
  smtp_use_ssl                     = data.infisical_secrets.cluster.secrets["smtp_use_ssl"].value
  smtp_use_tls                     = data.infisical_secrets.cluster.secrets["smtp_use_tls"].value
  mqtt_homeassistant_password_hash = data.infisical_secrets.cluster.secrets["mqtt_homeassistant_password_hash"].value
  mqtt_zigbee2mqtt_password_hash   = data.infisical_secrets.cluster.secrets["mqtt_zigbee2mqtt_password_hash"].value
  mqtt_octoprint_password_hash     = data.infisical_secrets.cluster.secrets["mqtt_octoprint_password_hash"].value
  grist_session_secret             = data.infisical_secrets.cluster.secrets["grist_session_secret"].value
  grist_oidc_client_id             = data.infisical_secrets.cluster.secrets["grist_oidc_client_id"].value
  grist_oidc_client_secret         = data.infisical_secrets.cluster.secrets["grist_oidc_client_secret"].value
  grist_oidc_idp_issuer            = data.infisical_secrets.cluster.secrets["grist_oidc_idp_issuer"].value
  mqtt_exporter_password_hash      = data.infisical_secrets.cluster.secrets["mqtt_exporter_password_hash"].value
  mqtt_exporter_password           = data.infisical_secrets.cluster.secrets["mqtt_exporter_password"].value
  hassio_token                     = data.infisical_secrets.cluster.secrets["hassio_token"].value
  unifi_username                   = data.infisical_secrets.cluster.secrets["unifi_username"].value
  unifi_password                   = data.infisical_secrets.cluster.secrets["unifi_password"].value

  sonarr_api_key             = data.infisical_secrets.cluster.secrets["sonarr_api_key"].value
  radarr_api_key             = data.infisical_secrets.cluster.secrets["radarr_api_key"].value
  lidarr_api_key             = data.infisical_secrets.cluster.secrets["lidarr_api_key"].value
  bazarr_api_key             = data.infisical_secrets.cluster.secrets["bazarr_api_key"].value
  prowlarr_api_key           = data.infisical_secrets.cluster.secrets["prowlarr_api_key"].value
  readarr_api_key            = data.infisical_secrets.cluster.secrets["readarr_api_key"].value
  plex_token                 = data.infisical_secrets.cluster.secrets["plex_token"].value
  plex_claim                 = data.infisical_secrets.cluster.secrets["plex_claim"].value
  tautulli_api_key           = data.infisical_secrets.cluster.secrets["tautulli_api_key"].value
  qbittorrent_admin_password = data.infisical_secrets.cluster.secrets["qbittorrent_admin_password"].value

  linkwarden_authentik_client_id     = data.infisical_secrets.cluster.secrets["linkwarden_authentik_client_id"].value
  linkwarden_authentik_client_secret = data.infisical_secrets.cluster.secrets["linkwarden_authentik_client_secret"].value
  linkwarden_nextauth_secret         = data.infisical_secrets.cluster.secrets["linkwarden_nextauth_secret"].value

  nocodb_oidc_client_id     = data.infisical_secrets.cluster.secrets["nocodb_oidc_client_id"].value
  nocodb_oidc_client_secret = data.infisical_secrets.cluster.secrets["nocodb_oidc_client_secret"].value
  nocodb_auth_secret        = data.infisical_secrets.cluster.secrets["nocodb_auth_secret"].value

  rally_client_id       = data.infisical_secrets.cluster.secrets["rally_client_id"].value
  rally_client_secret   = data.infisical_secrets.cluster.secrets["rally_client_secret"].value
  rally_secret_password = data.infisical_secrets.cluster.secrets["rally_secret_password"].value

  manyfold_secret_key_base = data.infisical_secrets.cluster.secrets["manyfold_secret_key_base"].value

  nextcloud_s3_access_key = data.infisical_secrets.cluster.secrets["nextcloud_s3_access_key"].value
  nextcloud_s3_secret_key = data.infisical_secrets.cluster.secrets["nextcloud_s3_secret_key"].value

  paperless_secret_key         = data.infisical_secrets.cluster.secrets["paperless_secret_key"].value
  paperless_oidc_client_id     = data.infisical_secrets.cluster.secrets["paperless_oidc_client_id"].value
  paperless_oidc_client_secret = data.infisical_secrets.cluster.secrets["paperless_oidc_client_secret"].value

  jellyseerr_api_key = data.infisical_secrets.cluster.secrets["jellyseerr_api_key"].value

  netbox_superuser_email       = data.infisical_secrets.cluster.secrets["netbox_superuser_email"].value
  netbox_superuser_name        = data.infisical_secrets.cluster.secrets["netbox_superuser_name"].value
  netbox_superuser_password    = data.infisical_secrets.cluster.secrets["netbox_superuser_password"].value
  netbox_aws_access_key_id     = data.infisical_secrets.cluster.secrets["netbox_aws_access_key_id"].value
  netbox_aws_secret_access_key = data.infisical_secrets.cluster.secrets["netbox_aws_secret_access_key"].value
  netbox_oidc_client_id        = data.infisical_secrets.cluster.secrets["netbox_oidc_client_id"].value
  netbox_oidc_client_secret    = data.infisical_secrets.cluster.secrets["netbox_oidc_client_secret"].value

  outline_aws_access_key_id     = data.infisical_secrets.cluster.secrets["outline_aws_access_key_id"].value
  outline_aws_secret_access_key = data.infisical_secrets.cluster.secrets["outline_aws_secret_access_key"].value
  outline_oidc_client_secret    = data.infisical_secrets.cluster.secrets["outline_oidc_client_secret"].value
  outline_secret_key            = data.infisical_secrets.cluster.secrets["outline_secret_key"].value
  outline_utils_secret          = data.infisical_secrets.cluster.secrets["outline_utils_secret"].value
  outline_oidc_client_id        = data.infisical_secrets.cluster.secrets["outline_oidc_client_id"].value

  romm_auth_secret_key     = data.infisical_secrets.cluster.secrets["romm_auth_secret_key"].value
  romm_igdb_client_id      = data.infisical_secrets.cluster.secrets["romm_igdb_client_id"].value
  romm_igdb_client_secret  = data.infisical_secrets.cluster.secrets["romm_igdb_client_secret"].value
  romm_mobygames_api_key   = data.infisical_secrets.cluster.secrets["romm_mobygames_api_key"].value
  romm_steamgriddb_api_key = data.infisical_secrets.cluster.secrets["romm_steamgriddb_api_key"].value

  mealie_oidc_client_id = data.infisical_secrets.cluster.secrets["mealie_oidc_client_id"].value

  ollama_oidc_client_id       = data.infisical_secrets.cluster.secrets["ollama_oidc_client_id"].value
  ollama_oidc_client_secret   = data.infisical_secrets.cluster.secrets["ollama_oidc_client_secret"].value
  ollama_google_pse_api_key   = data.infisical_secrets.cluster.secrets["ollama_google_pse_api_key"].value
  ollama_google_pse_engine_id = data.infisical_secrets.cluster.secrets["ollama_google_pse_engine_id"].value

  immich_db_password          = data.infisical_secrets.cluster.secrets["immich_db_password"].value
  blocky_db_password          = data.infisical_secrets.cluster.secrets["blocky_db_password"].value
  netbox_db_password          = data.infisical_secrets.cluster.secrets["netbox_db_password"].value
  paperless_db_password       = data.infisical_secrets.cluster.secrets["paperless_db_password"].value
  linkwarden_db_password      = data.infisical_secrets.cluster.secrets["linkwarden_db_password"].value
  nextcloud_db_password       = data.infisical_secrets.cluster.secrets["nextcloud_db_password"].value
  manyfold_db_password        = data.infisical_secrets.cluster.secrets["manyfold_db_password"].value
  mealie_db_password          = data.infisical_secrets.cluster.secrets["mealie_db_password"].value
  jellyseerr_db_password      = data.infisical_secrets.cluster.secrets["jellyseerr_db_password"].value
  windmill_db_password        = data.infisical_secrets.cluster.secrets["windmill_db_password"].value
  rally_db_password           = data.infisical_secrets.cluster.secrets["rally_db_password"].value
  outline_db_password         = data.infisical_secrets.cluster.secrets["outline_db_password"].value
  memos_db_password           = data.infisical_secrets.cluster.secrets["memos_db_password"].value
  vaultwarden_db_password     = data.infisical_secrets.cluster.secrets["vaultwarden_db_password"].value
  coder_db_password           = data.infisical_secrets.cluster.secrets["coder_db_password"].value
  nocodb_db_password          = data.infisical_secrets.cluster.secrets["nocodb_db_password"].value
  oneuptime_db_password       = data.infisical_secrets.cluster.secrets["oneuptime_db_password"].value
  zipline_db_password         = data.infisical_secrets.cluster.secrets["zipline_db_password"].value
  ollama_db_password          = data.infisical_secrets.cluster.secrets["ollama_db_password"].value
  silly_bot_database_password = data.infisical_secrets.cluster.secrets["silly_bot_database_password"].value

  chromadb_auth_token     = data.infisical_secrets.cluster.secrets["chromadb_auth_token"].value
  ollama_webui_secret_key = data.infisical_secrets.cluster.secrets["ollama_webui_secret_key"].value

  vaultwarden_installation_id  = data.infisical_secrets.cluster.secrets["vaultwarden_installation_id"].value
  vaultwarden_installation_key = data.infisical_secrets.cluster.secrets["vaultwarden_installation_key"].value

  opengist_oidc_client_id     = data.infisical_secrets.cluster.secrets["opengist_oidc_client_id"].value
  opengist_oidc_client_secret = data.infisical_secrets.cluster.secrets["opengist_oidc_client_secret"].value

  coder_oidc_client_id     = data.infisical_secrets.cluster.secrets["coder_oidc_client_id"].value
  coder_oidc_client_secret = data.infisical_secrets.cluster.secrets["coder_oidc_client_secret"].value

  stirling_pdf_oidc_client_id     = data.infisical_secrets.cluster.secrets["stirling_pdf_oidc_client_id"].value
  stirling_pdf_oidc_client_secret = data.infisical_secrets.cluster.secrets["stirling_pdf_oidc_client_secret"].value

  jabberwock_api_key   = data.infisical_secrets.cluster.secrets["jabberwock_api_key"].value
  lookingglass_api_key = data.infisical_secrets.cluster.secrets["lookingglass_api_key"].value
  floof_api_key        = data.infisical_secrets.cluster.secrets["floof_api_key"].value

  jellyfin_api_key = data.infisical_secrets.cluster.secrets["jellyfin_api_key"].value

  nocodb_admin_email      = data.infisical_secrets.cluster.secrets["nocodb_admin_email"].value
  nocodb_s3_access_key    = data.infisical_secrets.cluster.secrets["nocodb_s3_access_key"].value
  nocodb_s3_access_secret = data.infisical_secrets.cluster.secrets["nocodb_s3_access_secret"].value

  plane_aws_access_key_id     = data.infisical_secrets.cluster.secrets["plane_aws_access_key_id"].value
  plane_aws_secret_access_key = data.infisical_secrets.cluster.secrets["plane_aws_secret_access_key"].value
  plane_db_password           = data.infisical_secrets.cluster.secrets["plane_db_password"].value
  plane_secret_key            = data.infisical_secrets.cluster.secrets["plane_secret_key"].value

  nextcloud_api_key        = data.infisical_secrets.cluster.secrets["nextcloud_api_key"].value
  romm_username            = data.infisical_secrets.cluster.secrets["romm_username"].value
  romm_password            = data.infisical_secrets.cluster.secrets["romm_password"].value
  proxmox_api_token_id     = data.infisical_secrets.cluster.secrets["proxmox_api_token_id"].value
  proxmox_api_token_secret = data.infisical_secrets.cluster.secrets["proxmox_api_token_secret"].value
  authentik_api_key        = data.infisical_secrets.cluster.secrets["authentik_api_key"].value
  immich_api_key           = data.infisical_secrets.cluster.secrets["immich_api_key"].value
  homeassistant_api_key    = data.infisical_secrets.cluster.secrets["homeassistant_api_key"].value
  mealie_api_key           = data.infisical_secrets.cluster.secrets["mealie_api_key"].value
  paperless_api_key        = data.infisical_secrets.cluster.secrets["paperless_api_key"].value
  linkwarden_api_key       = data.infisical_secrets.cluster.secrets["linkwarden_api_key"].value
  grafana_username         = data.infisical_secrets.cluster.secrets["grafana_username"].value
  grafana_password         = data.infisical_secrets.cluster.secrets["grafana_password"].value
  qbittorrent_username     = data.infisical_secrets.cluster.secrets["qbittorrent_username"].value
  qbittorrent_password     = data.infisical_secrets.cluster.secrets["qbittorrent_password"].value
  audiobookshelf_api_key   = data.infisical_secrets.cluster.secrets["audiobookshelf_api_key"].value

  zipline_core_secret        = data.infisical_secrets.cluster.secrets["zipline_core_secret"].value
  zipline_oidc_client_id     = data.infisical_secrets.cluster.secrets["zipline_oidc_client_id"].value
  zipline_oidc_client_secret = data.infisical_secrets.cluster.secrets["zipline_oidc_client_secret"].value

  sabnzbd_api_key   = data.infisical_secrets.cluster.secrets["sabnzbd_api_key"].value
  openwebui_api_key = data.infisical_secrets.cluster.secrets["openwebui_api_key"].value

  silly_bot_infisical_client_id     = data.infisical_secrets.cluster.secrets["silly_bot_infisical_client_id"].value
  silly_bot_infisical_client_secret = data.infisical_secrets.cluster.secrets["silly_bot_infisical_client_secret"].value
  silly_bot_infisical_project_id    = data.infisical_secrets.cluster.secrets["silly_bot_infisical_project_id"].value
}

module "grafana" {
  depends_on = [module.cluster_base]
  source     = "./grafana"

  global_fqdn    = var.global_fqdn
  personal_email = data.infisical_secrets.cluster.secrets["personal_email"].value
  klaudia_email  = data.infisical_secrets.cluster.secrets["klaudia_email"].value
}
