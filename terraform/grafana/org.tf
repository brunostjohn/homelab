resource "grafana_organization" "zefirs_cloud" {
  name = "Zefir's Cloud"

  admins = [var.personal_email, "service_admin"]
}