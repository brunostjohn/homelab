resource "argocd_project" "networking" {
  metadata {
    name = "networking"
  }

  spec {
    description = "Network related applications"

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

resource "argocd_project" "storage" {
  metadata {
    name = "storage"
  }

  spec {
    description = "Storage handlers & provisioners"

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

resource "argocd_project" "cluster_mgmt" {
  metadata {
    name = "management"
  }

  spec {
    description = "Cluster management applications"

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

resource "argocd_project" "security" {
  metadata {
    name = "security"
  }

  spec {
    description = "Security related applications"

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