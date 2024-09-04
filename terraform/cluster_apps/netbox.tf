module "netbox_helm" {
  source = "../helm_deployment"

  chart           = "netbox"
  target_revision = "5.0.0-beta.82"
  repo_url        = "https://charts.netbox.oss.netboxlabs.com/"
  values = templatefile("${path.module}/templates/netbox.yml.tpl", {
    superuser_name        = var.netbox_superuser_name
    superuser_email       = var.netbox_superuser_email
    superuser_password    = var.netbox_superuser_password
    aws_access_key_id     = var.netbox_aws_access_key_id
    aws_secret_access_key = var.netbox_aws_secret_access_key
    global_fqdn           = var.global_fqdn
  })

  name             = "netbox"
  namespace        = "netbox"
  create_namespace = true

  create_ingress = false
}