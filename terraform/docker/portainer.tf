data "docker_registry_image" "portainer" {
  name = "portainer/portainer-ce:latest"
}

resource "docker_image" "portainer" {
  name = data.docker_registry_image.portainer.name
}

resource "docker_container" "portainer" {
  name  = "portainer"
  image = docker_image.portainer.image_id

  ports {
    internal = 8000
    external = 8007
  }

  ports {
    internal = 9443
    external = 9444
  }

  restart  = "always"
  hostname = "portainer"

  networks_advanced {
    name    = docker_network.reverse_proxy_network.id
    aliases = ["portainer"]
  }

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    container_path = "/data"
    host_path      = "/mnt/jabberwock/portainer/data"
  }
}