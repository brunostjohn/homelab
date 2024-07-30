resource "docker_network" "reverse_proxy_network" {
  name = "reverse_proxy_network"
}

resource "docker_network" "macvlan" {
  name = "macvlan_network"

  driver = "macvlan"

  ipam_config {
    subnet   = "10.0.0.0/16"
    ip_range = "10.0.0.0/16"
    gateway  = "10.0.0.1"
  }
}