resource "proxmox_virtual_environment_vm" "s2_k3s_master" {
  node_name = data.proxmox_virtual_environment_node.s2.node_name

  name        = "s3.m-nodes.zefirscloud.local"
  description = "K3S Master Node"
  tags = [
    "compute",
    "kubernetes",
    "nixos",
    "control-plane"
  ]

  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  on_boot         = true
  keyboard_layout = "en-us"

  cpu {
    architecture = "x86_64"
    cores        = 16
    type         = "host"
    units        = 1024
  }

  disk {
    aio          = "io_uring"
    backup       = true
    cache        = "none"
    datastore_id = "local-lvm"
    discard      = "ignore"
    file_format  = "raw"
    interface    = "scsi0"
    iothread     = true
    replicate    = true
    size         = 132
    ssd          = false
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = true
    type              = "4m"
  }

  memory {
    dedicated = 31744
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    enabled  = true
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
    timeout = "15m"
    trim    = true
  }

  startup {
    order = 2
  }
}