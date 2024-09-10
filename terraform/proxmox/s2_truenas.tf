resource "proxmox_virtual_environment_vm" "s2_truenas" {
  node_name = data.proxmox_virtual_environment_node.s2.node_name

  name        = "s2.truenas.zefirscloud.local"
  description = "TrueNAS Scale"
  tags = [
    "storage",
  ]

  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  on_boot         = true
  keyboard_layout = "en-us"

  cpu {
    architecture = "x86_64"
    cores        = 2
    type         = "host"
    units        = 1024
  }

  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "none"
    datastore_id      = "local-lvm"
    discard           = "ignore"
    file_format       = "raw"
    interface         = "scsi0"
    iothread          = true
    path_in_datastore = "vm-105-disk-1"
    replicate         = true
    size              = 20
    ssd               = false
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = true
    type              = "4m"
  }

  memory {
    dedicated = 4096
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
    type = "virtio"
    enabled = true
    timeout = "15m"
    trim = true
  }

  hostpci {
    device = "hostpci0"
    id     = "0000:03:00"
    pcie   = false
    rombar = true
    xvga   = false
  }

  startup {
    order = 1
  }
}