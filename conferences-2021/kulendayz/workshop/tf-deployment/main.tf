####################
# PROVIDERS
####################

provider "azurerm" {
  features {}
}

####################
# RESOURCE GROUP
####################

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

########################################
# AZURE SQL WITH FAILOVER
########################################

resource "azurerm_sql_server" "primary_sql_server" {
  name                         = var.primary_sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.primary_location
  version                      = "12.0"
  administrator_login          = var.username
  administrator_login_password = var.password

  tags = var.tags
}

resource "azurerm_sql_server" "secondary_sql_server" {
  name                         = var.secondary_sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.secondary_location
  version                      = "12.0"
  administrator_login          = var.username
  administrator_login_password = var.password

  tags = var.tags
}

resource "azurerm_sql_database" "sql_db" {
  name                             = var.database_name
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  server_name                      = azurerm_sql_server.primary_sql_server.name
  create_mode                      = "default"
  edition                          = "Standard"
  requested_service_objective_name = "S1"

  tags = var.tags
}

resource "azurerm_sql_failover_group" "sql_failover_group" {
  depends_on          = [azurerm_sql_database.sql_db]
  name                = var.failover_group_name
  databases           = [azurerm_sql_database.sql_db.id]
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.primary_sql_server.name

  partner_servers {
    id = azurerm_sql_server.secondary_sql_server.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}

resource "azurerm_sql_firewall_rule" "allow-azure-primarysql" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.primary_sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "allow-azure-secondarysql" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.secondary_sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

####################
# WEB APP
####################

resource "azurerm_app_service_plan" "app_plan" {
  name                = "kd2021-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "web_app" {

  depends_on          = [azurerm_sql_failover_group.sql_failover_group]
  name                = "kd2021-tf-deployment"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_plan.id

  site_config {
    dotnet_framework_version  = "v4.0"
    windows_fx_version        = "DOTNETCORE|3.1"
    always_on                 = true
    ftps_state                = "FtpsOnly"
    managed_pipeline_mode     = "Integrated"
    use_32_bit_worker_process = true
  }

  source_control {
    repo_url           = "https://github.com/wladinho31/kd-demo-app"
    branch             = "main"
    manual_integration = true
  }

  connection_string {
    name  = "WebApplicationDemoContext"
    type  = "SQLAzure"
    value = "Server=tcp:${var.failover_group_name}.database.windows.net,1433;Initial Catalog=${var.database_name};Persist Security Info=False;User ID=${var.username};Password=${var.password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}