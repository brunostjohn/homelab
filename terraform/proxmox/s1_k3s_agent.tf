resource "proxmox_virtual_environment_vm" "s1_k3s_agent" {
  node_name = data.proxmox_virtual_environment_node.s1.node_name

  name        = "s2.m-nodes.zefirscloud.local"
  description = "K3S Agent Node"
  tags = [
    "compute",
    "kubernetes",
    "nixos",
    "gpu"
  ]

  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  on_boot         = true
  keyboard_layout = "en-us"

  cpu {
    architecture = "x86_64"
    cores        = 9
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
    path_in_datastore = "vm-102-disk-1"
    replicate         = true
    size              = 92
    ssd               = false
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = true
    type              = "4m"
  }

  memory {
    dedicated = 23712
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

  startup {
    order = 2
  }

  hostpci {
    device = "hostpci0"
    id     = "0000:0b:00"
    pcie   = false
    rombar = true
    xvga   = false
  }

  usb {
    host = "1a86:7523"
    usb3 = false
  }
}