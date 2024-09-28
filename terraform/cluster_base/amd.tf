module "amd_plugin" {
  source     = "../helm_deployment"

  namespace        = "amd-device-plugin"
  create_namespace = true

  project = argocd_project.cluster_mgmt.metadata[0].name

  name            = "amd-plugin"
  chart           = "amd-device-plugin"
  repo_url        = "https://rocm.github.io/k8s-device-plugin/"
  target_revision = "0.13.0"
  values          = file("${path.module}/values/amd.yml")

  create_ingress = false
}