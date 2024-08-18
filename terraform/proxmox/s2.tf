data "proxmox_virtual_environment_node" "s2" {
  node_name = "s2"
}

resource "proxmox_virtual_environment_time" "s2_time" {
  node_name = data.proxmox_virtual_environment_node.s2.node_name
  time_zone = "Europe/Dublin"
}