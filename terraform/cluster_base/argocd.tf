resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true
  version          = "9.3.1"
  wait             = true

  values = [templatefile("${path.module}/values/argocd.yml.tpl", {
    global_fqdn        = var.global_fqdn
    oidc_client_id     = var.argocd_oidc_client_id
    oidc_client_secret = var.argocd_oidc_client_secret
    personal_email     = var.personal_email
    klaudia_email      = var.klaudia_email
  })]
}

resource "argocd_repository" "homelab_github" {
  depends_on = [helm_release.argocd, kubernetes_ingress_v1.argocd_ingress]
  type       = "git"
  repo       = "https://github.com/brunostjohn/homelab.git"
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  depends_on = [helm_release.argocd]

  wait_for_load_balancer = true

  metadata {
    namespace = "argocd"
    name      = "argocd-server"
  }

  spec {
    rule {
      host = "argocd.${var.global_fqdn}"
      http {
        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}