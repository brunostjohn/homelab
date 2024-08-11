resource "grafana_dashboard" "moqsuitto" {
  config_json = file("${path.module}/dashboards/mosquitto.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.apps.id
}