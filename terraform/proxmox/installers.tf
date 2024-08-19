resource "proxmox_virtual_environment_download_file" "nixos_24_05" {
  for_each = toset([data.proxmox_virtual_environment_node.s1.node_name, data.proxmox_virtual_environment_node.s2.node_name])

  content_type       = "iso"
  file_name          = "NixOS_24.05_Plasma.iso"
  url                = "https://channels.nixos.org/nixos-24.05/latest-nixos-plasma6-x86_64-linux.iso"
  node_name          = each.value
  datastore_id       = "local"
}

resource "proxmox_virtual_environment_download_file" "truenas_scale_24_04_2" {
  content_type       = "iso"
  file_name          = "TrueNAS-SCALE-24.04.2.iso"
  url                = "https://download.sys.truenas.net/TrueNAS-SCALE-Dragonfish/24.04.2/TrueNAS-SCALE-24.04.2.iso"
  node_name          = data.proxmox_virtual_environment_node.s1.node_name
  datastore_id       = "local"
}