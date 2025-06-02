# Terraform ignition configuration 
# All configuration options are detailed at
# https://www.terraform.io/docs/providers/ignition/index.html

data "ignition_config" "startup" {
  users = [
    data.ignition_user.core.rendered,
  ]

  files = [
    data.ignition_file.hostname.rendered,
    data.ignition_file.static_ip.rendered,
  ]
}

# Replace the default hostname with our generated one
data "ignition_file" "hostname" {
  path = "/etc/hostname"
  mode = 420 # decimal 0644

  content {
    content = var.hostname
  }
}

data "ignition_file" "static_ip" {

  path = "/etc/sysconfig/network-scripts/ifcfg-ens192"
  mode = "420"

  content {
    content = templatefile("${path.module}/files/ifcfg.tmpl", {
      dns_addresses  = var.dns_addresses
      machine_cidr   = var.machine_cidr
      ip_address     = var.ip_address
      cluster_domain = var.base_domain
      gateway        = var.vm_gateway
    })
  }
}

# Example configuration for the basic `core` user
data "ignition_user" "core" {
  name = "core"

  # Preferably use the ssh key auth instead
  ssh_authorized_keys = [var.ssh_public_key]
}
