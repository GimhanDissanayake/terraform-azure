output "appgw_id" {
  value = azurerm_application_gateway.appgw.id
}

output "appgw_managed_identity_id" {
  value = azurerm_user_assigned_identity.appgw_managed_identity.id
}