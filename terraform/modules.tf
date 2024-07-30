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
  source        = "./cluster_base"
  depends_on    = [module.unifi]
  argocd_values = file("values/argocd.yml")
}

module "cluster_apps" {
  source     = "./cluster_apps"
  depends_on = [module.unifi, module.cluster_base]
}

module "adguard" {
  source     = "./adguard"
  depends_on = [module.unifi, module.cluster_apps]

  meowbox_ipaddr = module.unifi.meowbox_ipaddr
}