resource "grafana_dashboard" "authentik" {
  config_json = file("${path.module}/dashboards/authentik.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.security.id
}

resource "grafana_dashboard" "cert_manager" {
  config_json = file("${path.module}/dashboards/cert-manager.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.security.id
}

resource "grafana_dashboard" "crowdsec" {
  config_json = file("${path.module}/dashboards/crowdsec.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.security.id
}