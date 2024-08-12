terraform {
  required_version = ">= 0.13"

  required_providers {
    readarr = {
      source  = "devopsarr/readarr"
      version = "2.1.0"
    }
  }
}