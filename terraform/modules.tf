module "unifi" {
  source             = "./unifi"
  username           = var.unifi_username
  password           = var.unifi_password
  api_url            = var.unifi_api_url
  site               = var.unifi_site
  wlan_home_password = var.unifi_wlan_home_password
}