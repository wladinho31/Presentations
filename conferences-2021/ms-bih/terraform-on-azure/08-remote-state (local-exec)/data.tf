####################
# DATA
####################

data "azurerm_resource_group" "rg" {
  name = "project-terraform-bih"
}

data "azurerm_storage_account_sas" "remote_state_sas" {
  depends_on        = [azurerm_storage_container.container]
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "17520h")

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
  }
}