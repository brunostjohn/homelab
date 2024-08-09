module "unifi" {
  source             = "./unifi"
  wlan_home_password = var.unifi_wlan_home_password
  wlan_home_ssid     = var.unifi_wlan_home_ssid
}

module "docker" {
  source     = "./docker"
  depends_on = [module.unifi]
}

module "cluster_base" {
  source     = "./cluster_base"
  depends_on = [module.unifi]

  argocd_values          = file("values/argocd.yml")
  longhorn_values        = file("values/longhorn.yml")
  nfs_provisioner_values = file("values/nfs.yml")
  akri_values            = file("values/akri.yml")

  global_fqdn = var.global_fqdn
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.unifi, module.cluster_base]

  homelab_repo                     = module.cluster_base.homelab_repo
  adguard_username                 = var.adguard_username
  adguard_password                 = var.adguard_password
  k8s_dashboard_values             = file("values/dashboard.yml")
  k8s_dashboard_token              = var.k8s_dashboard_token
  minio_username                   = var.minio_username
  minio_password                   = var.minio_password
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
  grist_oidc_client_id = var.grist_oidc_client_id
  grist_oidc_client_secret = var.grist_oidc_client_secret
  grist_oidc_idp_issuer = var.grist_oidc_idp_issuer
}

module "adguard" {
  source     = "./adguard"
  depends_on = [module.unifi, module.cluster_apps]

  meowbox_ipaddr  = module.unifi.meowbox_ipaddr
  cluster_ipaddr  = var.cluster_ipaddr
  node1_pi_ipaddr = module.unifi.node1_pi_ipaddr
  node2_pi_ipaddr = module.unifi.node2_pi_ipaddr
  node3_pi_ipaddr = module.unifi.node3_pi_ipaddr
}