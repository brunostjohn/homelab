resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = "kyverno"
  }
}

resource "argocd_application" "kyverno" {
  depends_on = [kubernetes_namespace.kyverno]

  wait = true

  metadata {
    name      = "kyverno"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url        = "https://kyverno.github.io/kyverno"
      chart           = "kyverno"
      target_revision = "3.2.6"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.kyverno.metadata[0].name
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      sync_options = [
        "Replace=true"
      ]
    }
  }
}