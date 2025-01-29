terraform {
  required_version = ">= 0.13"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "3.18.1"
    }
  }
}