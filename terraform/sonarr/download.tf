resource "sonarr_download_client_qbittorrent" "qbittorrent" {
  name                       = "qBittorrent"
  host                       = "qbittorrent.entertainment.svc.cluster.local"
  port                       = 8080
  username                   = "admin"
  password                   = var.qbittorrent_password
  enable                     = true
  priority                   = 1
  initial_state              = 0
  remove_completed_downloads = true
  remove_failed_downloads    = true
  tv_category                = "Shows"
  tv_imported_category       = "Shows (Imported)"
  recent_tv_priority         = 1
  older_tv_priority          = 0
}