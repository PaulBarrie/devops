terraform {
  required_version = ">= 0.12.0"
  required_providers {
    external = {
      version = ">= 2.1.0"
      source  = "registry.terraform.io/hashicorp/external"
    }
    kubernetes-engine = {
      version = ">= 2.1.0"
      source  = "registry.terraform.io/hashicorp/external"
    }
  }
}

