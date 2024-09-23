module "jabberwock_iscsi_helm" {
  source = "../helm_deployment"

  chart           = "democratic-csi"
  target_revision = "0.14.6"
  repo_url        = "https://democratic-csi.github.io/charts/"

  name              = "jabberwock-iscsi"
  namespace         = "kube-system"
  server_side_apply = true

  values = templatefile("${path.module}/values/jabberwock-iscsi.yml.tpl", {
    api_key = var.jabberwock_api_key
  })

  create_namespace = false
  create_ingress   = false
}

module "jabberwock_nfs_helm" {
  source = "../helm_deployment"

  chart           = "democratic-csi"
  target_revision = "0.14.6"
  repo_url        = "https://democratic-csi.github.io/charts/"

  name              = "jabberwock-nfs"
  namespace         = "kube-system"
  server_side_apply = true

  values = templatefile("${path.module}/values/jabberwock-nfs.yml.tpl", {
    api_key = var.jabberwock_api_key
  })

  create_namespace = false
  create_ingress   = false
}