data "proxmox_virtual_environment_node" "s1" {
  node_name = "s1"
}

resource "proxmox_virtual_environment_time" "s1_time" {
  node_name = data.proxmox_virtual_environment_node.s1.node_name
  time_zone = "Europe/Dublin"
}