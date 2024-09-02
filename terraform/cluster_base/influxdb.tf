module "influxdb_helm" {
  depends_on = [module.kube_prometheus_helm, argocd_application.nfs_provisioner]
  source     = "../helm_deployment"

  name             = "influxdb"
  namespace        = "monitoring"
  create_namespace = false

  chart           = "influxdb"
  target_revision = "4.12.5"
  repo_url        = "https://helm.influxdata.com/"

  values = file("${path.module}/values/influxdb.yml")

  create_ingress = false
}