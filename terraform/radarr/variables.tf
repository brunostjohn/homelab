variable "qbittorrent_password" {
  type        = string
  description = "The password for the qBittorrent client"
}

variable "discord_webhook_url" {
  type        = string
  description = "The Discord webhook URL for notifications"
}

variable "auth_username" {
  type        = string
  description = "The username for basic authentication"
}

variable "auth_password" {
  type        = string
  description = "The password for basic authentication"
}

variable "sabnzbd_api_key" {
  type = string
}