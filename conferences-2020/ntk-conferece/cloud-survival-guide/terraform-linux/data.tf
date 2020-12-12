####################
# DATA
####################

data "azurerm_resource_group" "rg" {
  name = ""
}

data "azurerm_subnet" "linux_subnet" {
  name                 = ""
  virtual_network_name = ""
  resource_group_name  = ""
}

data "azurerm_storage_account" "sa" {
  name                = ""
  resource_group_name = ""
}