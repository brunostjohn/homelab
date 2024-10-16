module "rabbitmq_operator_helm" {
  source = "../helm_deployment"

  chart           = "rabbitmq-cluster-operator"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "4.3.25"
  values          = file("${path.module}/values/rabbitmq-operator.yml")

  namespace        = kubernetes_namespace.databases.metadata[0].name
  create_namespace = false
  name             = "rabbitmq-operator"

  create_ingress = false
}

resource "argocd_application" "rabbitmq_cluster" {
  metadata {
    name      = "rabbitmq-cluster"
    namespace = "argocd"
  }

  wait = true

  spec {
    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/rabbitmq"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.databases.metadata[0].name
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}
