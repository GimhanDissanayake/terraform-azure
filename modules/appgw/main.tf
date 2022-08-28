# default values
locals {
  backend_address_pool_name              = "defaultaddresspool"
  frontend_port_name                     = "port_80"
  public_frontend_ip_configuration_name  = "appGwPublicFrontendIp"
  private_frontend_ip_configuration_name = "appGwPrivateFrontendIp"
  http_setting_name                      = "defaulthttpsetting"
  listener_name                          = "defaultlistner"
  request_routing_rule_name              = "defaultrule"
  routing_rule_priority                  = 20000
}

resource "azurerm_user_assigned_identity" "appgw_managed_identity" {
  name                = join("-", ["appgw", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance, "managed-id"])
  resource_group_name = var.resource_group_name
  location            = var.region

  tags = {
    env = var.stage
  }
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_user_assigned_identity.appgw_managed_identity.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw_managed_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

# Public IP
resource "azurerm_public_ip" "appgw_pub_ip" {
  name                = join("-", ["appgw", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance, "pub-ip"])
  resource_group_name = var.resource_group_name
  location            = var.region
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.appgw_zones

  tags = {
    env = var.stage
  }
}

# App Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = join("-", ["appgw", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  resource_group_name = var.resource_group_name
  location            = var.region

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      request_routing_rule,
      id,
      tags,
      probe,
      url_path_map
    ]
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  frontend_ip_configuration {
    name                 = local.public_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pub_ip.id
  }

  frontend_ip_configuration {
    name                          = local.private_frontend_ip_configuration_name
    private_ip_address            = var.appgw_frontend_private_ip
    private_ip_address_allocation = "Static"
    subnet_id                     = var.appgw_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = var.appgw_subnet_id
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = local.routing_rule_priority
  }

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_sku_capacity
  }

  zones        = var.appgw_zones
  enable_http2 = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw_managed_identity.id]
  }

  ssl_certificate {
    name                = var.ssl_certificate_name
    key_vault_secret_id = var.key_vault_secret_id
    password            = ""
  }

  waf_configuration {
    enabled          = var.appgw_waf_enabled
    firewall_mode    = var.appgw_waf_mode
    rule_set_type    = var.appgw_waf_ruleset_type
    rule_set_version = var.appgw_waf_ruleset_version
  }

  tags = {
    env = var.stage
  }

}

