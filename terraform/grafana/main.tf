terraform {
  required_version = ">= 0.13"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "4.8.0"
    }
  }
}