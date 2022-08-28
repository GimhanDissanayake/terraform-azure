resource "azurerm_resource_group" "resource_group" {
  name     = join("-", ["rg", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  location = var.region
  tags = {
    env = var.stage
  }
}
