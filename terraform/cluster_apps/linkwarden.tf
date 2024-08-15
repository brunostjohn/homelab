resource "kubernetes_namespace" "linkwarden" {
  metadata {
    name = "linkwarden"
  }
}

resource "kubernetes_secret" "linkwarden_secrets" {
  metadata {
    name      = "linkwarden-secrets"
    namespace = kubernetes_namespace.linkwarden.metadata[0].name
  }

  data = {
    "nextauth-secret"         = var.linkwarden_nextauth_secret
    "authentik-client-secret" = var.linkwarden_authentik_client_secret
  }
}

resource "kubernetes_config_map" "linkwarden_config" {
  metadata {
    name      = "linkwarden-config"
    namespace = kubernetes_namespace.linkwarden.metadata[0].name
  }

  data = {
    "authentik-issuer"    = "https://auth.${var.global_fqdn}/application/o/linkwarden"
    "authentik-client-id" = var.linkwarden_authentik_client_id
    "nextauth-url"        = "https://links.${var.global_fqdn}/api/v1/auth"
  }
}

module "linkwarden_postgres" {
  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.linkwarden.metadata[0].name
  name             = "linkwarden-postgres"
  create_namespace = false
  create_ingress   = false

  chart           = "postgresql"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "15.5.21"
  values          = file("${path.module}/values/linkwarden-postgres.yml")
}

resource "argocd_application" "linkwarden" {
  depends_on = [kubernetes_namespace.linkwarden, kubernetes_secret.linkwarden_secrets, kubernetes_config_map.linkwarden_config, module.linkwarden_postgres]

  wait = true

  metadata {
    name      = "linkwarden"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/linkwarden"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.homeassistant.metadata[0].name
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

module "linkwarden_ingress" {
  depends_on = [argocd_application.linkwarden]

  source = "../ingress"

  hosts     = ["links.${var.global_fqdn}"]
  port      = 3000
  service   = "linkwarden"
  namespace = kubernetes_namespace.linkwarden.metadata[0].name
}