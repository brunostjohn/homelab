resource "sonarr_download_client_qbittorrent" "qbittorrent" {
  name                       = "qBittorrent"
  host                       = "qbittorrent.entertainment.svc.cluster.local"
  use_ssl                    = false
  port                       = 8080
  username                   = "admin"
  password                   = var.qbittorrent_password
  enable                     = true
  priority                   = 2
  initial_state              = 0
  remove_completed_downloads = true
  remove_failed_downloads    = true
  tv_category                = "shows"
  tv_imported_category       = "shows-imported"
  recent_tv_priority         = 1
  older_tv_priority          = 0
}

resource "sonarr_download_client_sabnzbd" "sabnzbd" {
  name                       = "SABnzbd"
  host                       = "sabnzbd.entertainment.svc.cluster.local"
  port                       = 8080
  api_key                    = var.sabnzbd_api_key
  enable                     = true
  priority                   = 1
  remove_completed_downloads = true
  remove_failed_downloads    = true
  tv_category                = "shows"
  recent_tv_priority         = 1
  older_tv_priority          = 0
}