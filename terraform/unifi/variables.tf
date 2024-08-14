variable "wlan_home_password" {
  type        = string
  description = "Password for the home WLAN"
}

variable "wlan_home_ssid" {
  type        = string
  description = "SSID for the home WLAN"
}

variable "cluster_ip" {
  type        = string
  description = "IP address of the cluster"
}