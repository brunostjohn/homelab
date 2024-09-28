resource "radarr_host" "host" {
  launch_browser  = true
  port            = 7878
  url_base        = ""
  bind_address    = "*"
  application_url = ""
  instance_name   = "Radarr"
  proxy = {
    enabled = false
  }
  ssl = {
    enabled                = false
    certificate_validation = "disabled"
  }
  logging = {
    analytics_enabled = false
    log_level         = "info"
    console_log_level = "info"
    log_size_limit    = 10
  }
  backup = {
    folder    = "Backups"
    interval  = 7
    retention = 28
  }
  authentication = {
    method   = "basic"
    username = var.auth_username
    password = var.auth_password
  }
  update = {
    mechanism = "docker"
    branch    = "master"
  }
}