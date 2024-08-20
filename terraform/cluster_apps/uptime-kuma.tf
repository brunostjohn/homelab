module "uptime_kuma_helm" {
  source = "../helm_deployment"

  name             = "uptime-kuma"
  namespace        = "uptime-kuma"
  create_namespace = true

  service_name   = "uptime-kuma"
  service_port   = 3001
  create_ingress = true

  hosts = ["uptimekuma.${var.global_fqdn}"]

  chart           = "uptime-kuma"
  repo_url        = "https://helm.irsigler.cloud"
  target_revision = "2.19.3"

  values = file("${path.module}/values/uptime-kuma.yml")
}