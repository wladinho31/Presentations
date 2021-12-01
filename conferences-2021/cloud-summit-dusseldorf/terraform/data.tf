####################
# DATA
####################

data "azurerm_resource_group" "rg" {
  name = "cloudsummit-rg"
}

data "azurerm_subnet" "linux_subnet" {
  name                 = "servers"
  virtual_network_name = "cloudsummit-vnet"
  resource_group_name  = "cloudsummit-rg"
}

data "azurerm_storage_account" "sa" {
  name                = "cloudsummitdemo30112021"
  resource_group_name = "cloudsummit-rg"
}