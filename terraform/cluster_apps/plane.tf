module "plane_helm" {
  source = "../helm_deployment"

  name             = "plane"
  namespace        = kubernetes_namespace.productivity.metadata[0].name
  create_namespace = false

  chart           = "plane-ce"
  repo_url        = "https://helm.plane.so/"
  target_revision = "1.0.26"
  values = templatefile("${path.module}/templates/plane.yml.tpl", {
    global_fqdn           = var.global_fqdn
    db_password           = urlencode(var.plane_db_password)
    aws_access_key_id     = var.plane_aws_access_key_id
    aws_secret_access_key = var.plane_aws_secret_access_key
    secret_key            = var.plane_secret_key
    rabbitmq_password     = var.plane_rabbitmq_password
  })

  create_ingress = false
}
