module "telegraf_helm" {
  depends_on = [module.influxdb_helm]
  source     = "../helm_deployment"

  namespace        = "monitoring"
  create_namespace = false
  name             = "telegraf"

  chart           = "telegraf"
  target_revision = "1.8.53"
  repo_url        = "https://helm.influxdata.com/"
  values          = file("${path.module}/values/telegraf.yml")

  create_ingress = false
}