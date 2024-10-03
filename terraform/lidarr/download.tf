resource "lidarr_download_client_qbittorrent" "qbittorrent" {
  name                       = "qBittorrent"
  host                       = "qbittorrent.entertainment.svc.cluster.local"
  port                       = 8080
  username                   = "admin"
  password                   = var.qbittorrent_password
  enable                     = true
  priority                   = 1
  music_category             = "music"
  music_imported_category    = "music-imported"
  initial_state              = 0
  recent_music_priority      = 1
  remove_completed_downloads = true
  remove_failed_downloads    = true
  older_music_priority       = 0
}

resource "lidarr_download_client_sabnzbd" "sabnzbd" {
  name                       = "SABnzbd"
  host                       = "sabnzbd.entertainment.svc.cluster.local"
  port                       = 8080
  api_key                    = var.sabnzbd_api_key
  enable                     = true
  priority                   = 2
  music_category             = "music"
  recent_music_priority      = 1
  remove_completed_downloads = true
  remove_failed_downloads    = true
  older_music_priority       = 0
}