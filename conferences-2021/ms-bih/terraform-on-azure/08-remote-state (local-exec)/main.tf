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
  depends_on           = [azurerm_storage_account.sa]
  name                 = var.container_name
  storage_account_name = azurerm_storage_account.sa.name
}

resource "null_resource" "export_backend_config" {
  depends_on = [data.azurerm_storage_account_sas.remote_state_sas]

  provisioner "local-exec" {
    command = <<EOT
      New-Item -Name "backend-config.txt" -ItemType File
      Add-Content -Path .\backend-config.txt -Value 'storage_account_name = "${azurerm_storage_account.sa.name}"'
      Add-Content -Path .\backend-config.txt -Value 'container_name       = "${var.container_name}"'
      Add-Content -Path .\backend-config.txt -Value 'key                  = "terraform.tfstate"'
      Add-Content -Path .\backend-config.txt -Value 'sas_token            = "${data.azurerm_storage_account_sas.remote_state_sas.sas}"'
    EOT

    interpreter = ["PowerShell", "-Command"]
  }
}