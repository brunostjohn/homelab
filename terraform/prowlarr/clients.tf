resource "prowlarr_download_client_qbittorrent" "qbittorrent" {
  name          = "qBittorrent"
  username      = "admin"
  password      = var.qbittorrent_admin_password
  host          = "qbittorrent.entertainment.svc.cluster.local"
  port          = 8080
  enable        = true
  priority      = 1
  initial_state = 0
  category      = "prowlarr"
}

resource "prowlarr_indexer_proxy_flaresolverr" "flaresolverr" {
  name            = "FlareSolverr"
  request_timeout = 10
  host            = ""
}