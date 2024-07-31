resource "kubernetes_namespace" "longhorn" {
  metadata {
    name = "longhorn-system"
  }
}

resource "kubernetes_config_map" "longhorn_path" {
  depends_on = [kubernetes_namespace.longhorn, argocd_application.kyverno]

  metadata {
    name      = "longhorn-nixos-path"
    namespace = kubernetes_namespace.longhorn.metadata[0].name
  }

  data = {
    "PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  }
}

resource "kubernetes_manifest" "longhorn_nixos_path" {
  depends_on = [argocd_application.kyverno, kubernetes_config_map.longhorn_path]

  manifest = {
    "apiVersion" = "kyverno.io/v1"
    "kind"       = "ClusterPolicy"
    "metadata" = {
      "name" = "longhorn-add-nixos-path"
      "annotations" = {
        "policies.kyverno.io/title"       = "Add Environment Variables from ConfigMap"
        "policies.kyverno.io/subject"     = "Pod"
        "policies.kyverno.io/category"    = "Other"
        "policies.kyverno.io/description" = "Longhorn invokes executables on the host system, and needs to be aware of the host systems PATH. This modifies all deployments such that the PATH is explicitly set to support NixOS based systems."
      }
    }
    "spec" = {
      "rules" = [
        {
          "name" = "add-env-vars"
          "match" = {
            "resources" = {
              "kinds" = ["Pod"]
              "namespaces" = [
                kubernetes_namespace.longhorn.metadata[0].name
              ]
            }
          }
          "mutate" = {
            "patchStrategicMerge" = {
              "spec" = {
                "initContainers" = [
                  {
                    "(name)" = "*"
                    "envFrom" = [
                      {
                        "configMapRef" = {
                          "name" = kubernetes_config_map.longhorn_path.metadata[0].name
                        }
                      }
                    ]
                  }
                ]
                "containers" = [
                  {
                    "(name)" = "*"
                    "envFrom" = [
                      {
                        "configMapRef" = {
                          "name" = kubernetes_config_map.longhorn_path.metadata[0].name
                        }
                      }
                    ]
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}

resource "argocd_application" "longhorn" {
  depends_on = [argocd_application.metallb, kubernetes_namespace.longhorn, argocd_application.kyverno, kubernetes_manifest.longhorn_nixos_path]

  wait = true

  metadata {
    name      = "longhorn"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url        = "https://charts.longhorn.io"
      chart           = "longhorn"
      target_revision = "1.6.2"

      helm {
        values = var.longhorn_values
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "longhorn-system"
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
}

resource "kubernetes_ingress_v1" "longhorn_ingress" {
  depends_on = [argocd_application.longhorn]

  metadata {
    namespace = "longhorn-system"
    name      = "longhorn-ingress"
  }

  wait_for_load_balancer = true

  spec {
    rule {
      host = "longhorn.local"
      http {
        path {
          backend {
            service {
              name = "longhorn-frontend"
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