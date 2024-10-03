variable "qbittorrent_password" {
  type        = string
  description = "The password for the qBittorrent client"
}

variable "discord_webhook_url" {
  type        = string
  description = "The Discord webhook URL for notifications"
}

variable "sabnzbd_api_key" {
  type = string
}