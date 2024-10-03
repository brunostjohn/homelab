variable "sonarr_api_key" {
  type        = string
  description = "API key for Sonarr"
}

variable "radarr_api_key" {
  type        = string
  description = "API key for Radarr"
}

variable "lidarr_api_key" {
  type        = string
  description = "API key for Lidarr"
}

variable "readarr_api_key" {
  type        = string
  description = "API key for Readarr"
}

variable "qbittorrent_admin_password" {
  type        = string
  description = "Admin password for qBittorrent"
}

variable "auth_username" {
  type        = string
  description = "Username for basic authentication"
}

variable "auth_password" {
  type        = string
  description = "Password for basic authentication"
}

variable "discord_webhook_url" {
  type        = string
  description = "Discord webhook URL"
}

variable "sabnzbd_api_key" {
  type = string
}