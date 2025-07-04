//////
// vSphere variables
//////

variable "vsphere_cluster" {
  type        = string
  description = "This is the name of the vSphere cluster."
}

variable "vsphere_datacenter" {
  type        = string
  description = "This is the name of the vSphere data center."
}

variable "vm_template" {
  type        = string
  description = "This is the name of the VM template to clone."
}

variable "ocpgym_name" {
  type        = string
  description = "The OpenShift gym identifier (i.e. gym-310002f78j-008m2axz)."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
}

variable "hostname" {
  type        = string
  description = "Hostname of vm"
}

variable "base_domain" {
  type        = string
  description = "Domain name"
  default     = "gym.lan"
}

variable "ip_address" {
  type        = string
  description = "IP address of vm"
}

variable "vm_dns_addresses" {
  type        = string
  description = "Comma separated list of DNS Servers"
  default     = "192.168.252.1"
}

variable "env" {
  type        = string
  description = "environment string"
}
