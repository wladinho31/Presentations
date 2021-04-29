####################
# PROVIDERS
####################

provider "azurerm" {
  features {}
}

####################
# RESOURCES
####################

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
  tags                = var.tags
  depends_on          = [azurerm_public_ip.vm_pip]

  ip_configuration {
    name                          = "primary-ip-configuration"
    subnet_id                     = data.azurerm_subnet.linux_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
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
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.sa.primary_blob_endpoint
  }

  computer_name                   = var.vm_name
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  tags = var.tags
}

resource "null_resource" "deploy_nginx" {
  depends_on = [azurerm_linux_virtual_machine.vm]

  provisioner "file" {
    source      = "learn-azure-v2"
    destination = "."

    connection {
      type     = "ssh"
      user     = var.username
      password = var.password
      host     = azurerm_public_ip.vm_pip.ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install nginx -y",
      "sudo cp -r learn-azure-v2/* /var/www/html"
    ]

    connection {
      type     = "ssh"
      user     = var.username
      password = var.password
      host     = azurerm_public_ip.vm_pip.ip_address
    }
  }
}