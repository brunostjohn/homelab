resource "docker_network" "reverse_proxy_network" {
  name = "reverse_proxy_network"
}

resource "docker_network" "macvlan" {
  name = "macvlan_network"

  driver = "macvlan"

  ipam_config {
    subnet   = "192.168.1.0/24"
    ip_range = "192.168.1.0/24"
    gateway  = "192.168.1.1"
  }
}