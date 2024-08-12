resource "grafana_dashboard" "radarr" {
  config_json = file("${path.module}/dashboards/radarr.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "media_stack" {
  config_json = file("${path.module}/dashboards/media-stack.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "plex" {
  config_json = file("${path.module}/dashboards/plex.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "qbittorrent" {
  config_json = file("${path.module}/dashboards/qbittorrent.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "overseerr" {
  config_json = file("${path.module}/dashboards/overseerr.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "flaresolverr" {
  config_json = file("${path.module}/dashboards/flaresolverr.json")
  folder      = grafana_folder.entertainment.id
  org_id      = grafana_organization.zefirs_cloud.id
}