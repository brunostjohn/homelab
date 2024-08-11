resource "grafana_dashboard" "minio" {
  config_json = file("${path.module}/dashboards/minio.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.storage.id
}

resource "grafana_dashboard" "longhorn" {
  config_json = file("${path.module}/dashboards/longhorn.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.storage.id
}