resource "kubernetes_runtime_class_v1" "nvidia" {
  metadata {
    name = "nvidia"
    labels = {
      "app.kubernetes.io/component" = "gpu-operator"
    }
  }

  handler = "nvidia-cdi"
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
  values          = file("${path.module}/values/nvidia.yml")

  create_ingress = false
}

module "nvidia_observability" {
  depends_on = [module.nvidia_plugin]
  source     = "../helm_deployment"

  namespace        = "nvidia-device-plugin"
  create_namespace = false

  project = argocd_project.cluster_mgmt.metadata[0].name

  name            = "nvidia-observability"
  chart           = "dcgm-exporter"
  repo_url        = "https://nvidia.github.io/dcgm-exporter/helm-charts"
  target_revision = "v3.5.0"

  values = file("${path.module}/values/nvidia_exporter.yml")

  create_ingress = false
}
