####################
# OUTPUTS
####################

output "vm_name" {
  value = azurerm_windows_virtual_machine.vm.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm_pip.ip_address
}

output "vm_username" {
  value = var.username
}

output "vm_password" {
  value     = var.password
  sensitive = true
}