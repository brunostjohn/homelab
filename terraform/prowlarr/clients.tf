resource "prowlarr_download_client_qbittorrent" "qbittorrent" {
  name          = "qBittorrent"
  username      = "admin"
  password      = var.qbittorrent_admin_password
  host          = "qbittorrent.entertainment.svc.cluster.local"
  port          = 8080
  use_ssl       = false
  enable        = true
  priority      = 1
  initial_state = 0
  category      = "prowlarr"
}

resource "prowlarr_indexer_proxy_flaresolverr" "flaresolverr" {
  name            = "FlareSolverr"
  request_timeout = 60
  tags = [
    prowlarr_tag.flare.id,
  ]
  host = "http://flaresolverr.entertainment.svc.cluster.local:8191/"
}

resource "prowlarr_download_client_sabnzbd" "sabnzbd" {
  name     = "SABnzbd"
  host     = "sabnzbd.entertainment.svc.cluster.local"
  port     = 8080
  api_key  = var.sabnzbd_api_key
  category = "prowlarr"
  enable   = true
  priority = 2
}