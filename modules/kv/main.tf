data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = join("-", ["kv", var.project_short, var.stage, replace(lower(var.region), " ", ""), var.instance])
  location                    = var.region
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = {
    env = var.stage
  }
}

