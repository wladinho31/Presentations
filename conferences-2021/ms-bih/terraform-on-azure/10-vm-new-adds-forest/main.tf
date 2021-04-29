########################################
# PROVIDERS
########################################

provider "azurerm" {
  features {}
}

########################################
# BACKEND
########################################

terraform {
  backend "azurerm" {
  }
}

########################################
# RESOURCES
########################################

resource "azurerm_public_ip" "vm_pip" {
  name                = "${var.vm_name}-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on          = [azurerm_public_ip.vm_pip]
  tags                = var.tags

  ip_configuration {
    name                          = "primary-ip-configuration"
    subnet_id                     = data.azurerm_subnet.windows_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  depends_on            = [azurerm_network_interface.vm_nic]
  name                  = var.vm_name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "${var.vm_name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.sa.primary_blob_endpoint
  }

  computer_name  = var.vm_name
  admin_username = var.username
  admin_password = var.password

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "install_new_adds_forest" {
  name                       = "InstallNewAddsForest"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  publisher                  = "Microsoft.Compute"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/wladinho31/deployment-scripts/master/install_new_adds_forest.ps1"
      ]
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File install_new_adds_forest.ps1 -DomainName contoso.com -DomainNetBiosName CONTOSO -DSRMPassword 'Pa$$w0rd1234'"
    }
  PROTECTED_SETTINGS  
}