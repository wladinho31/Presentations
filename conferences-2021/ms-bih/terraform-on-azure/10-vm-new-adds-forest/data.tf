####################
# DATA
####################

data "azurerm_resource_group" "rg" {
  name = "project-terraform"
}

data "azurerm_subnet" "windows_subnet" {
  name                 = "windows-subnet"
  virtual_network_name = "project-terraform-vnet"
  resource_group_name  = "project-terraform"
}

data "azurerm_storage_account" "sa" {
  name                = "projectterraform150"
  resource_group_name = "project-terraform"
}