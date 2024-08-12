resource "radarr_download_client_qbittorrent" "qbittorrent" {
  name     = "qBittorrent"
  host     = "http://qbittorrent.entertainment.svc.cluster.local"
  port     = 8080
  username = "admin"
  password = var.qbittorrent_password
  enable = true
  priority = 1
  movie_category = "Movies"
  movie_imported_category = "Movies (Imported)"
  initial_state = 0
  recent_movie_priority = 1
  remove_completed_downloads = true
  remove_failed_downloads = true
  older_movie_priority = 0
}