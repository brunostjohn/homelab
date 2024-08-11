resource "grafana_folder" "kubernetes" {
  title = "Kubernetes"
  uid   = "kubernetes"
}

resource "grafana_folder" "kubernetes_networking" {
  title             = "Networking"
  parent_folder_uid = grafana_folder.kubernetes.uid
  uid               = "networking"
}

resource "grafana_folder" "prometheus" {
  title             = "Prometheus"
  uid               = "prometheus"
  parent_folder_uid = grafana_folder.monitoring.uid
}

resource "grafana_folder" "node_exporter" {
  title = "Node Exporter"
  uid   = "node-exporter"
}

resource "grafana_folder" "use_method" {
  title             = "USE Method"
  uid               = "use-method"
  parent_folder_uid = grafana_folder.node_exporter.uid
}

resource "grafana_folder" "kubernetes_compute" {
  title             = "Compute Resources"
  uid               = "compute-resources"
  parent_folder_uid = grafana_folder.kubernetes.uid
}

resource "grafana_folder" "apps" {
  title = "Apps"
  uid   = "apps"
}

resource "grafana_folder" "monitoring" {
  title             = "Monitoring"
  uid               = "monitoring"
  parent_folder_uid = grafana_folder.apps.uid
}

resource "grafana_folder" "networking" {
  title             = "Networking"
  uid               = "networking-apps"
  parent_folder_uid = grafana_folder.apps.uid
}

resource "grafana_folder" "security" {
  title             = "Security"
  uid               = "security"
  parent_folder_uid = grafana_folder.apps.uid
}

resource "grafana_folder" "storage" {
  title             = "Storage"
  uid               = "storage"
  parent_folder_uid = grafana_folder.apps.uid
}