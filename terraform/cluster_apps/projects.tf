resource "argocd_project" "smarthome" {
  metadata {
    name = "smarthome"
  }

  spec {
    description = "Smart home applications"

    destination {
      server    = "*"
      namespace = "*"
    }

    source_repos = ["*"]

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}