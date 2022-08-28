resource "azurerm_virtual_network" "vnet" {
  name                = join("-", ["vnet", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  location            = var.region
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_spaces

  tags = {
    env = var.stage
  }
}
