terraform {
  required_version = ">= 0.13"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.62.0"
    }
  }
}