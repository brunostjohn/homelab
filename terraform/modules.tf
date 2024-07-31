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

  longhorn_auth_secret = var.longhorn_auth_secret
  argocd_values        = file("values/argocd.yml")
  longhorn_values      = file("values/longhorn.yml")
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.unifi, module.cluster_base]

  homelab_repo     = module.cluster_base.homelab_repo
  adguard_username = var.adguard_username
  adguard_password = var.adguard_password
}

module "adguard" {
  source     = "./adguard"
  depends_on = [module.unifi, module.cluster_apps]

  meowbox_ipaddr  = module.unifi.meowbox_ipaddr
  cluster_ipaddr  = var.cluster_ipaddr
  node2_pi_ipaddr = module.unifi.node2_pi_ipaddr
  node3_pi_ipaddr = module.unifi.node3_pi_ipaddr
}