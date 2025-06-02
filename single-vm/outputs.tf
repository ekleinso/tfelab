# -[Output]--------------------------------------------------------------
output "remote_ssh" {
  value = format("ssh core@%s", var.ip_address)
}
