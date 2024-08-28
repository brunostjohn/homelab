module "nextcloud_helm" {
  source = "../helm_deployment"

  name             = "nextcloud"
  namespace        = "nextcloud"
  create_namespace = true

  repo_url        = "https://nextcloud.github.io/helm/"
  chart           = "nextcloud"
  target_revision = "5.5.3"

  values = templatefile("${path.module}/templates/nextcloud.yml.tpl", {
    global_fqdn   = var.global_fqdn
    smtp_host     = var.smtp_host
    smtp_port     = var.smtp_port
    smtp_username = var.smtp_username
    smtp_password = var.smtp_password
    s3_access_key = var.nextcloud_s3_access_key
    s3_secret_key = var.nextcloud_s3_secret_key
    s3_host       = "minio-svc.minio.svc.cluster.local:9000"
  })

  create_ingress = false
}