resource "argocd_application" "app" {
  wait = var.wait

  metadata {
    name      = var.name
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.create_namespace ? kubernetes_namespace.ns[0].metadata[0].name : var.namespace
    }

    project = var.project

    source {
      repo_url        = var.repo_url
      chart           = var.chart
      target_revision = var.target_revision

      helm {
        values = var.values
      }
    }

    sync_policy {
      dynamic "automated" {
        for_each = var.auto_sync ? [true] : []
        content {
          prune       = true
          self_heal   = true
          allow_empty = true
        }
      }

      sync_options = var.server_side_apply ? ["ServerSideApply=true"] : []

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