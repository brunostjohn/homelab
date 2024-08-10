resource "kubernetes_runtime_class_v1" "nvidia" {
  metadata {
    name = "nvidia"
    labels = {
      "app.kubernetes.io/component" = "gpu-operator"
    }
  }

  handler = "nvidia"
}

module "nvidia_plugin" {
  depends_on = [kubernetes_runtime_class_v1.nvidia]
  source     = "../helm_deployment"

  namespace        = "nvidia-device-plugin"
  create_namespace = true

  project = argocd_project.cluster_mgmt.metadata[0].name

  name            = "nvidia-plugin"
  chart           = "nvidia-device-plugin"
  repo_url        = "https://nvidia.github.io/k8s-device-plugin"
  target_revision = "v0.16.2"
  values          = var.nvidia_plugin_values

  create_ingress = false
}