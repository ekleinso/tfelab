
# -[Provider]--------------------------------------------------------------
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# -[Resources]-------------------------------------------------------------

locals {
  vsphere_resource_pool = format("/%s/host/%s/Resources/Cluster Resource Pool/Gym Member Resource Pool/%s", var.vsphere_datacenter, var.vsphere_cluster, var.ocpgym_id)
  vsphere_folder        = format("/%s/%s", var.vsphere_cluster, var.ocpgym_id)
  vm_network            = format("%s-segment", var.ocpgym_id)
  vsphere_datastore     = format("%s-storage", var.ocpgym_id)

  machine_cidr = format("%s.0/24", join(".", slice(split(".", var.ip_address), 0, 3)))
  hostname     = format("%s-%s", var.ocpgym_id, var.hostname)
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = local.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = local.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name          = local.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "ignition" {
  source         = "./ignition"
  ssh_public_key = var.ssh_public_key
  base_domain    = var.base_domain
  hostname       = local.hostname
  ip_address     = var.ip_address
  dns_addresses  = split(",", var.vm_dns_addresses)
  machine_cidr   = local.machine_cidr
  vm_gateway     = cidrhost(local.machine_cidr, 1)
}

module "singlevm" {
  source = "./vmware"

  ignition = module.ignition.singlevm

  hostname              = local.hostname
  ip_address            = var.ip_address
  resource_pool_id      = data.vsphere_resource_pool.resource_pool.id
  datastore_id          = data.vsphere_datastore.datastore.id
  datacenter_id         = data.vsphere_datacenter.dc.id
  network_id            = data.vsphere_network.network.id
  folder_id             = local.vsphere_folder
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  machine_cidr = local.machine_cidr

  num_cpus      = 2
  memory        = 8192
  disk_size     = 16
  dns_addresses = split(",", var.vm_dns_addresses)
  vm_gateway    = cidrhost(local.machine_cidr, 1)
}
