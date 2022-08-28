resource "azurerm_static_site" "stapp" {
  name                = join("-", ["stapp", var.project, var.stage, replace(lower(var.stapp_region), " ", ""), var.instance])
  resource_group_name = var.resource_group_name
  location            = var.stapp_region
  sku_tier            = var.stapp_sku_tier
  sku_size            = var.stapp_sku_size

  tags = {
    env = var.stage
  }
}