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

resource "argocd_project" "entertainment" {
  metadata {
    name = "entertainment"
  }

  spec {
    description = "Entertainment applications"

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