resource "azurerm_kubernetes_cluster" "aks" {
  name                = join("-", ["aks", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  location            = var.region
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      azure_policy_enabled,
      microsoft_defender
    ]
  }

  default_node_pool {
    name                = "agentpool"
    vm_size             = var.default_node_pool_size
    node_count          = 1
    enable_auto_scaling = false
    zones               = ["1", "2", "3"]
    vnet_subnet_id      = var.subnet_id
    max_pods            = "110"
    kubelet_disk_type   = "OS"
  }

  dns_prefix = join("-", ["aks", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance, "dns"])

  azure_policy_enabled             = true
  http_application_routing_enabled = false

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = false
    secret_rotation_interval = "2m"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "loadBalancer" # default
    service_cidr       = "10.0.0.0/16"
    ip_versions        = ["IPv4"]
    load_balancer_sku  = "standard"
    load_balancer_profile {
      managed_outbound_ip_count = 1
    }
  }

  oms_agent {
    log_analytics_workspace_id = var.logaw_id
  }

  private_cluster_enabled             = true
  private_dns_zone_id                 = "System"
  private_cluster_public_fqdn_enabled = true
  public_network_access_enabled       = false
  role_based_access_control_enabled   = true
  sku_tier                            = var.aks_sku

  tags = {
    env = var.stage
  }
}

# Grant AcrPull access to aks cluster to acr scope
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# Grant contributor access to ingress controller identity to appgw scope
resource "azurerm_role_assignment" "apic_to_appgw" {
  principal_id                     = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  role_definition_name             = "Contributor"
  scope                            = var.aapgw_id
  skip_service_principal_aad_check = true
}

# Grant read access to ingress controller identity to main resource_group
resource "azurerm_role_assignment" "apic_to_main_rg" {
  principal_id                     = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  role_definition_name             = "Reader"
  scope                            = var.main_rg_id
  skip_service_principal_aad_check = true
}

# Grant Managed Identity Operator access to ingress controller identity to appgw managed identity
resource "azurerm_role_assignment" "apic_to_appgw_managed_id" {
  principal_id                     = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  role_definition_name             = "Managed Identity Operator"
  scope                            = var.aapgw_managed_identity_id
  skip_service_principal_aad_check = true
}