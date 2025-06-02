variable "hostname" {
  type        = string
  description = "Hostname of registry"
}

variable "base_domain" {
  type        = string
  description = "Domain name"
}

variable "ip_address" {
  type        = string
  description = "IP address of host"
}

variable "ssh_public_key" {
  type        = string
  description = "Path to your ssh public key.  If left blank we will generate one."
  default     = ""
}

variable "machine_cidr" {
  type        = string
  description = "IP address of host"
  default     = "192.168.252.0/24"
}

variable "vm_gateway" {
  type    = string
  default = null
}

variable "dns_addresses" {
  type = list(string)
}
