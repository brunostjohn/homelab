variable "username" {
  type        = string
  description = "Unifi controller username"
}

variable "password" {
  type        = string
  description = "Unifi controller password"
}

variable "api_url" {
  type        = string
  description = "Unifi controller API URL"
  validation {
    condition     = can(regex("https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)", var.api_url))
    error_message = "unifi_api_url must be a valid URL"
  }
}

variable "site" {
  type        = string
  description = "Unifi controller site"
}

variable "wlan_home_password" {
  type        = string
  description = "Password for the home WLAN"
}