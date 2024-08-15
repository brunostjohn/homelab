resource "prowlarr_host" "host" {
  instance_name   = "Prowlarr"
  url_base        = ""
  port            = 9696
  application_url = ""
  bind_address    = "*"
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
  }
  backup = {
    folder    = "Backups"
    interval  = 7
    retention = 28
  }
  update = {
    branch               = "master"
    mechanism            = "docker"
    update_automatically = false
  }

  authentication = {
    method   = "basic"
    username = var.auth_username
    password = var.auth_password
  }
}