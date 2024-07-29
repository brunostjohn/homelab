resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true
  version          = "7.3.11"

  values = [file("values/argocd.yml")]
}

resource "argocd_repository" "homelab_github" {
  depends_on      = [helm_release.argocd]
  type            = "git"
  repo            = "git@github.com:brunostjohn/homelab.git"
  ssh_private_key = file("~/.ssh/id_ed25519")
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  depends_on = [helm_release.argocd]

  metadata {
    namespace = "argocd"
    name      = "argocd-server"
  }

  spec {
    rule {
      host = "argocd.local"
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