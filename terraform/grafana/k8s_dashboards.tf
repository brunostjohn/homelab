resource "grafana_dashboard" "alertmanager_overview" {
  config_json = file("${path.module}/dashboards/alertmanager-overview.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.monitoring.id
}

resource "grafana_dashboard" "api_server" {
  config_json = file("${path.module}/dashboards/apiserver.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "controller_manager" {
  config_json = file("${path.module}/dashboards/controller-manager.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "grafana_overview" {
  config_json = file("${path.module}/dashboards/grafana-overview.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.monitoring.id
}

resource "grafana_dashboard" "k8s_resources_cluster" {
  config_json = file("${path.module}/dashboards/k8s-resources-cluster.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_resources_multicluster" {
  config_json = file("${path.module}/dashboards/k8s-resources-multicluster.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_resources_namespace" {
  config_json = file("${path.module}/dashboards/k8s-resources-namespace.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "cluster_total" {
  config_json = file("${path.module}/dashboards/cluster-total.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_networking.id
}

resource "grafana_dashboard" "k8s_resources_node" {
  config_json = file("${path.module}/dashboards/k8s-resources-node.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_resources_pod" {
  config_json = file("${path.module}/dashboards/k8s-resources-pod.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_resources_workload" {
  config_json = file("${path.module}/dashboards/k8s-resources-workload.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_nvidia_gpu" {
  config_json = file("${path.module}/dashboards/nvidia.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "k8s_resources_workloads_namespace" {
  config_json = file("${path.module}/dashboards/k8s-resources-workloads-namespace.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_compute.id
}

resource "grafana_dashboard" "kubelet" {
  config_json = file("${path.module}/dashboards/kubelet.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "namespace_by_pod" {
  config_json = file("${path.module}/dashboards/namespace-by-pod.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_networking.id
}

resource "grafana_dashboard" "namespace_by_workload" {
  config_json = file("${path.module}/dashboards/namespace-by-workload.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_networking.id
}

resource "grafana_dashboard" "node_cluster_rsrc_use" {
  config_json = file("${path.module}/dashboards/node-cluster-rsrc-use.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.use_method.id
}

resource "grafana_dashboard" "node_rsrc_use" {
  config_json = file("${path.module}/dashboards/node-rsrc-use.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.use_method.id
}

resource "grafana_dashboard" "nodes_darwin" {
  config_json = file("${path.module}/dashboards/nodes-darwin.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.node_exporter.id
}

resource "grafana_dashboard" "nodes" {
  config_json = file("${path.module}/dashboards/nodes.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.node_exporter.id
}

resource "grafana_dashboard" "persistent_volume_usage" {
  config_json = file("${path.module}/dashboards/persistentvolumeusage.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "pod_total" {
  config_json = file("${path.module}/dashboards/pod-total.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_networking.id
}

resource "grafana_dashboard" "prometheus_remote_write" {
  config_json = file("${path.module}/dashboards/prometheus-remote-write.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.prometheus.id
}

resource "grafana_dashboard" "prometheus" {
  config_json = file("${path.module}/dashboards/prometheus.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.prometheus.id
}

resource "grafana_dashboard" "proxy" {
  config_json = file("${path.module}/dashboards/proxy.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "scheduler" {
  config_json = file("${path.module}/dashboards/scheduler.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes.id
}

resource "grafana_dashboard" "workload_total" {
  config_json = file("${path.module}/dashboards/workload-total.json")
  org_id      = grafana_organization.zefirs_cloud.id
  folder      = grafana_folder.kubernetes_networking.id
}