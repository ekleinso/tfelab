terraform {
  required_version = ">= 0.13"
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source = "hashicorp/tls"
    }
    vsphere = {
      source = "vmware/vsphere"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
    }
  }

}
