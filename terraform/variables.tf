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