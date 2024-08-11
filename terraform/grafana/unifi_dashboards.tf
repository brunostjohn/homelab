resource "grafana_dashboard" "unifi_aps" {
  config_json = file("${path.module}/dashboards/unifi-access-points.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}

resource "grafana_dashboard" "unifi_client_insights" {
  config_json = file("${path.module}/dashboards/unifi-client-insights.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}

resource "grafana_dashboard" "unifi_switches" {
  config_json = file("${path.module}/dashboards/unifi-switches.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}

resource "grafana_dashboard" "unifi_sites" {
  config_json = file("${path.module}/dashboards/unifi-sites.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}

resource "grafana_dashboard" "unifi_gateways" {
  config_json = file("${path.module}/dashboards/unifi-gateways.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}

resource "grafana_dashboard" "unifi_client_dpi" {
  config_json = file("${path.module}/dashboards/unifi-client-dpi.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.unifi.id
}