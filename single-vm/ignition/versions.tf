terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "~> 2.3.0"
    }
  }
  required_version = ">= 0.13"
}