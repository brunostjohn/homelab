resource "proxmox_virtual_environment_vm" "s3_truenas" {
  node_name = data.proxmox_virtual_environment_node.s3.node_name

  name        = "s3.truenas.zefirscloud.local"
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
    cores        = 1
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
    path_in_datastore = "vm-106-disk-1"
    replicate         = true
    size              = 15
    ssd               = false
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = true
    type              = "4m"
  }

  memory {
    dedicated = 2048
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

  hostpci {
    device = "hostpci0"
    id     = "0000:01:00"
    pcie   = false
    rombar = true
    xvga   = false
  }

  startup {
    order = 1
  }
}