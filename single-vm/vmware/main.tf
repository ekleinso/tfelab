locals {
  disks = compact(tolist([var.disk_size, var.extra_disk_size == 0 ? "" : var.extra_disk_size]))
  disk_sizes = zipmap(
    range(length(local.disks)),
    local.disks
  )
}

resource "vsphere_virtual_machine" "vm" {

  name = var.hostname

  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  num_cpus         = var.num_cpus
  memory           = var.memory
  guest_id         = var.guest_id
  folder           = var.folder_id
  enable_disk_uuid = "true"

  cpu_hot_add_enabled    = "true"
  cpu_hot_remove_enabled = "true"
  memory_hot_add_enabled = "true"

  dynamic "disk" {
    for_each = local.disk_sizes
    content {
      label            = "disk${disk.key}"
      size             = disk.value
      thin_provisioned = var.disk_thin_provisioned
      unit_number      = disk.key
    }
  }

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  nested_hv_enabled = var.nested_hv_enabled

  network_interface {
    network_id = var.network_id
  }

  clone {
    template_uuid = var.template_uuid
  }

  extra_config = {
    "guestinfo.ignition.config.data"           = base64encode(var.ignition)
    "guestinfo.ignition.config.data.encoding"  = "base64"
    "guestinfo.afterburn.initrd.network-kargs" = "ip=${var.ip_address}::${var.vm_gateway}:${cidrnetmask(var.machine_cidr)}:${var.hostname}:ens192:none ${join(" ", formatlist("nameserver=%v", var.dns_addresses))}"
  }
}