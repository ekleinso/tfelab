terraform {
  required_providers {
    template = {
      source = "hashicorp/template"
    }
    vsphere = {
      source = "vmware/vsphere"
    }
  }
  required_version = ">= 0.13"
}