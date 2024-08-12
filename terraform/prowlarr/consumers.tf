resource "prowlarr_application_radarr" "radarr" {
  name         = "Radarr"
  base_url     = "http://radarr.entertainment.svc.cluster.local:7878"
  api_key      = var.radarr_api_key
  prowlarr_url = "http://prowlarr.entertainment.svc.cluster.local:9696"
  sync_level   = "fullSync"
}

resource "prowlarr_application_lidarr" "lidarr" {
  name         = "Lidarr"
  base_url     = "http://lidarr.entertainment.svc.cluster.local:8686"
  api_key      = var.lidarr_api_key
  prowlarr_url = "http://prowlarr.entertainment.svc.cluster.local:9696"
  sync_level   = "fullSync"
}