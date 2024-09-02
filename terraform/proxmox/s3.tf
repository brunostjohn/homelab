data "proxmox_virtual_environment_node" "s3" {
  node_name = "s3"
}

resource "proxmox_virtual_environment_time" "s3_time" {
  node_name = data.proxmox_virtual_environment_node.s3.node_name
  time_zone = "Europe/Dublin"
}