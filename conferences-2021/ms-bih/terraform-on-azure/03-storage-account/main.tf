####################
# PROVIDERS
####################

provider "azurerm" {
  features {}
}

####################
# RESOURCES
####################

resource "random_integer" "random" {
  min = 100
  max = 999
}

resource "azurerm_storage_account" "sa" {
  name                      = "${var.sa_name}${random_integer.random.result}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "hot"
  enable_https_traffic_only = true
  tags                      = var.tags
}

resource "azurerm_storage_container" "container" {
  name                 = var.container_name
  storage_account_name = azurerm_storage_account.sa.name
  depends_on           = [azurerm_storage_account.sa]
}