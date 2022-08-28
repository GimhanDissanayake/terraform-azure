variable "stage" {
  type        = string
  description = "Environment."
}

variable "region" {
  type        = string
  description = "Operating Region."
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "project_short" {
  type        = string
  description = "Project short name."
}

variable "vnet_address_spaces" {
  type        = list(any)
  description = "Vnet address space."
}

variable "pub_sn_1_address_prefixes" {
  type        = list(any)
  description = "Public subnet address prefixes."
}

variable "pvt_sn_1_address_prefixes" {
  type        = list(any)
  description = "Private subnet address prefixes."
}

variable "appgw_sn_1_address_prefixes" {
  type        = list(any)
  description = "App gateway subnet address prefixes."
}

variable "pvt_endpoints_sn_1_address_prefixes" {
  type        = list(any)
  description = "Private endpoint subnet address prefixes."
}

# NSG for subnets
variable "pub_sn_1_nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "The values for each NSG rule "
}

variable "pvt_sn_1_nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "The values for each NSG rule "
}

# App GW
variable "appgw_frontend_private_ip" {
  type        = string
  description = "Private IP to use with App gateway frontend."
}

variable "appgw_sku_name" {
  type        = string
  description = "App Gateway sku."
}

variable "appgw_sku_tier" {
  type        = string
  description = "App Gateway sku tier."
}

variable "appgw_sku_capacity" {
  type        = string
  description = "App Gateway sku capacity."
}

variable "appgw_zones" {
  type        = list(any)
  description = "App Gateway zones."
}

variable "appgw_waf_enabled" {
  type        = string
  description = "appgw_waf_enabled"
}

variable "appgw_waf_mode" {
  type        = string
  description = "appgw_waf_mode"
}

variable "appgw_waf_ruleset_type" {
  type        = string
  description = "appgw_waf_ruleset_type"
}

variable "appgw_waf_ruleset_version" {
  type        = string
  description = "appgw_waf_ruleset_version"
}

# Bastion server
variable "vm_size" {
  type        = string
  description = "VM size."
}

variable "source_image_publisher" {
  type        = string
  description = "source_image_publisher."
}

variable "source_image_offer" {
  type        = string
  description = "source_image_offer."
}

variable "source_image_sku" {
  type        = string
  description = "source_image_sku."
}

variable "source_image_version" {
  type        = string
  description = "source_image_sku."
}

# NSG for bastion
variable "bastion_nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "The values for each NSG rule "
}

# kv
variable "ssl_cert_file_location" {
  type        = string
  description = "ssl_cert_file_location."
}

variable "kv_ssl_cert_prefix" {
  type        = string
  description = "Prefix for the ssl cert name import into kv."
}

# aks
variable "aks_sku" {
  type        = string
  description = "AKS sku to use."
}

variable "default_node_pool_size" {
  type        = string
  description = "default_node_pool_size"
}

# sqldb_001
variable "sql_server_version" {
  type        = string
  description = "sql_server_version."
}

variable "sql_server_adminusername" {
  type        = string
  description = "sql_server_adminusername."
  sensitive   = true
}

variable "sql_server_adminuserpassword" {
  type        = string
  description = "sql_server_adminuserpassword."
  sensitive   = true
}

variable "sql_server_minimalTlsVersion" {
  type        = string
  description = "sql_server_minimalTlsVersion."
}

variable "sql_server_publicnetworkaccess" {
  type        = string
  description = "sql_server_publicnetworkaccess."
}

variable "sqldb_max_size_gb" {
  type        = string
  description = "sqldb_max_size_gb."
}

variable "sqldb_read_scale_enabled" {
  type        = string
  description = "sqldb_read_scale_enabled."
}

variable "sqldb_sku_name" {
  type        = string
  description = "sqldb_sku_name."
}

variable "sqldb_zone_redundant_enabled" {
  type        = string
  description = "sqldb_zone_redundant_enabled."
}

variable "sqldb_geo_backup_enabled" {
  type        = string
  description = "sqldb_geo_backup_enabled."
}

# sqldb_data_001
variable "sql_data_001_server_version" {
  type        = string
  description = "sql_server_version."
}

variable "sql_data_001_server_adminusername" {
  type        = string
  description = "sql_server_adminusername."
  sensitive   = true
}

variable "sql_data_001_server_adminuserpassword" {
  type        = string
  description = "sql_server_adminuserpassword."
  sensitive   = true
}

variable "sql_data_001_server_minimalTlsVersion" {
  type        = string
  description = "sql_server_minimalTlsVersion."
}

variable "sql_data_001_server_publicnetworkaccess" {
  type        = string
  description = "sql_server_publicnetworkaccess."
}

variable "sqldb_data_001_max_size_gb" {
  type        = string
  description = "sqldb_max_size_gb."
}

variable "sqldb_data_001_read_scale_enabled" {
  type        = string
  description = "sqldb_read_scale_enabled."
}

variable "sqldb_data_001_sku_name" {
  type        = string
  description = "sqldb_sku_name."
}

variable "sqldb_data_001_zone_redundant_enabled" {
  type        = string
  description = "sqldb_zone_redundant_enabled."
}

variable "sqldb_data_001_geo_backup_enabled" {
  type        = string
  description = "sqldb_geo_backup_enabled."
}

# stapp
variable "stapp_region" {
  type        = string
  description = "Operating Region for the static web app."
}

variable "stapp_sku_tier" {
  type        = string
  description = "stapp_sku_tier."
}

variable "stapp_sku_size" {
  type        = string
  description = "stapp_sku_size."
}

