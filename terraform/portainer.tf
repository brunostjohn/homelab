resource "kubernetes_namespace" "portainer" {
  metadata {
    name = "portainer"
  }
}

resource "kubernetes_service_account" "portainer_sa_clusteradmin" {
  metadata {
    name      = "portainer-sa-clusteradmin"
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "portainer_crb_clusteradmin" {
  metadata {
    name = "portainer-crb-clusteradmin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.portainer_sa_clusteradmin.metadata[0].name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }
}

resource "kubernetes_service" "portainer_agent" {
  metadata {
    name      = "portainer-agent"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    annotations = {
      "metallb.universe.tf/allow-shared-ip"        = "key-192.168.1.2"
      "metallb.universe.tf/ip-allocated-from-pool" = "pool"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "portainer-agent"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 9001
      target_port = 9001
    }
  }
}

resource "kubernetes_service" "portainer_agent_headless" {
  metadata {
    name      = "portainer-agent-headless"
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }

  spec {
    cluster_ip = "None"

    selector = {
      app = "portainer-agent"
    }
  }
}

resource "kubernetes_deployment" "portainer_agent" {
  metadata {
    name      = "portainer-agent"
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "portainer-agent"
      }
    }

    template {
      metadata {
        labels = {
          app = "portainer-agent"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.portainer_sa_clusteradmin.metadata[0].name

        container {
          name  = "portainer-agent"
          image = "portainer/agent:2.19.5"

          image_pull_policy = "Always"

          env {
            name  = "LOG_LEVEL"
            value = "DEBUG"
          }

          env {
            name  = "AGENT_CLUSTER_ADDR"
            value = "portainer-agent-headless"
          }

          env {
            name = "KUBERNETES_POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          port {
            container_port = 9001
            protocol       = "TCP"
          }
        }
      }
    }
  }
}