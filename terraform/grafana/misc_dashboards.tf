resource "grafana_dashboard" "proxmox" {
  config_json = file("${path.module}/dashboards/proxmox.json")
  org_id      = grafana_organization.zefirs_cloud.id
}