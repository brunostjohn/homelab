resource "grafana_dashboard" "proxmox" {
  config_json = file("${path.module}/dashboards/proxmox.json")
  org_id      = grafana_organization.zefirs_cloud.id
}

resource "grafana_dashboard" "idrac" {
  config_json = file("${path.module}/dashboards/idrac.json")
  org_id      = grafana_organization.zefirs_cloud.id
}