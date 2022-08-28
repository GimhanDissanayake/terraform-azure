output "public_ip" {
  value = azurerm_public_ip.vm_pub_ip.ip_address
}

output "name" {
  value = join("-", ["vm", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
}

output "nic_id" {
  value = azurerm_network_interface.nic.id
}

