module "floof_iscsi_helm" {
  source = "../helm_deployment"

  chart           = "democratic-csi"
  target_revision = "0.14.6"
  repo_url        = "https://democratic-csi.github.io/charts/"

  name              = "floof-iscsi"
  namespace         = "kube-system"
  server_side_apply = true

  values = templatefile("${path.module}/values/floof-iscsi.yml.tpl", {
    api_key = var.floof_api_key
  })

  create_namespace = false
  create_ingress   = false
}

module "floof_nfs_helm" {
  source = "../helm_deployment"

  chart           = "democratic-csi"
  target_revision = "0.14.6"
  repo_url        = "https://democratic-csi.github.io/charts/"

  name              = "floof-nfs"
  namespace         = "kube-system"
  server_side_apply = true

  values = templatefile("${path.module}/values/floof-nfs.yml.tpl", {
    api_key = var.floof_api_key
  })

  create_namespace = false
  create_ingress   = false
}