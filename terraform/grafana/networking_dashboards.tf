resource "grafana_dashboard" "adguard_home" {
  config_json = file("${path.module}/dashboards/adguard-home.json")
  folder      = grafana_folder.networking.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "traefik" {
  config_json = file("${path.module}/dashboards/traefik.json")
  folder      = grafana_folder.networking.id
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "metallb" {
  config_json = file("${path.module}/dashboards/metallb.json")
  folder      = grafana_folder.networking.id
  org_id      = grafana_organization.zefirs_cloud.id
}