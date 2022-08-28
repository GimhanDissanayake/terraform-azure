# Create Security Group to access web
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_name}-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # lifecycle {
  #   ignore_changes = [
  #     security_rule
  #   ]
  # }

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value["name"]
      description                = security_rule.value["description"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }

  tags = {
    env = var.stage
  }
}