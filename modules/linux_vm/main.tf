# Public IP
resource "azurerm_public_ip" "vm_pub_ip" {
  name                = join("-", ["vm", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance, "pub-ip"])
  resource_group_name = var.resource_group_name
  location            = var.region
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    env = var.stage
  }
}

# Network interface of VM
resource "azurerm_network_interface" "nic" {
  name                = join("-", ["vm", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance, "nic"])
  location            = var.region
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pub_ip.id
  }

  tags = {
    env = var.stage
  }
}

# VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = join("-", ["vm", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  resource_group_name = var.resource_group_name
  location            = var.region
  size                = var.vm_size
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  user_data = var.user_data_script

  tags = {
    env = var.stage
  }

}