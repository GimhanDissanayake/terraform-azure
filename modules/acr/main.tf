resource "azurerm_container_registry" "acr" {
  name                          = join("", ["acr", title(var.project), title(var.stage), title(replace(lower(var.region), " ", "")), var.instance])
  resource_group_name           = var.resource_group_name
  location                      = var.region
  sku                           = "Premium"
  public_network_access_enabled = false
  admin_enabled                 = false

  tags = {
    env = var.stage
  }
}