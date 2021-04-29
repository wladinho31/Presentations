####################
# OUTPUTS
####################

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_account_sas" {
  value     = data.azurerm_storage_account_sas.remote_state_sas.sas
  sensitive = true
}