resource "azurerm_log_analytics_workspace" "logaw" {
  name                = join("-", ["logaw", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    env = var.stage
  }
}
