# Common variables
stage         = "dev" # env specific
project       = "<PROJECT_NAME>"
project_short = "<PROJECT_NAME_SHORT>"
region        = "<REGION>"
# Resource Group variables - All common
# Vnet variables
vnet_address_spaces = ["10.10.0.0/16"] # env specific
# Subnets
pub_sn_1_address_prefixes           = ["10.10.11.0/24"] # env specific
pvt_sn_1_address_prefixes           = ["10.10.22.0/24"] # env specific
appgw_sn_1_address_prefixes         = ["10.10.0.0/28"]  # env specific
pvt_endpoints_sn_1_address_prefixes = ["10.10.0.16/28"] # env specific
# nsg for subnets
pub_sn_1_nsg_rules = [
  {
    name                       = "allow_all_inbound"
    description                = "allow_all_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "allow_all_outbound"
    description                = "allow_all_outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

pvt_sn_1_nsg_rules = [
  {
    name                       = "allow_all_internal"
    description                = "allow_all_internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.10.0.0/16" # env specific
    destination_address_prefix = "*"
  },
  {
    name                       = "deny_all_inbound"
    description                = "deny_all_inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "allow_all_outbound"
    description                = "allow_all_outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

# App Gateway
appgw_sku_name            = "WAF_v2"
appgw_sku_tier            = "WAF_v2"
appgw_sku_capacity        = 1
appgw_zones               = ["1", "2", "3"]
appgw_frontend_private_ip = "10.10.0.10" # env specific
appgw_waf_enabled         = true
appgw_waf_mode            = "Prevention"
appgw_waf_ruleset_type    = "OWASP"
appgw_waf_ruleset_version = "3.2"
# Bastion Server
vm_size                = "Standard_B2s" # "Standard_B1ls"
source_image_publisher = "Canonical"
source_image_offer     = "0001-com-ubuntu-server-focal"
source_image_sku       = "20_04-lts-gen2"
source_image_version   = "latest"
# NSG for the Bastion Server
bastion_nsg_rules = [
  {
    name                       = "allow_ssh_temp_admin"
    description                = "allow_ssh_temp_admin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "YOUR_PUBLIC_IP/32"
    destination_address_prefix = "*"
  },
  {
    name                       = "allow_all_outbound"
    description                = "allow_all_outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
# kv
kv_ssl_cert_prefix     = "dvsslcert"
ssl_cert_file_location = "../../files/ssl_certs/file.pfx" # env specific
# aks
aks_sku = "Free"
default_node_pool_size = "Standard_B2ms" 
# sqldb_001 
sql_server_version             = "12.0"
sql_server_adminusername       = "project_namedevadmin" # env specific
sql_server_minimalTlsVersion   = "1.2"
sql_server_publicnetworkaccess = "true"
sqldb_max_size_gb              = "5"
sqldb_read_scale_enabled       = false
sqldb_sku_name                 = "S0"
sqldb_zone_redundant_enabled   = false
sqldb_geo_backup_enabled       = true
sql_server_adminuserpassword   = "**************" # env specific
# sqldb_data_001
sql_data_001_server_version             = "12.0"
sql_data_001_server_adminusername       = "project_namedevdataadmin" # env specific
sql_data_001_server_minimalTlsVersion   = "1.2"
sql_data_001_server_publicnetworkaccess = "true"
sqldb_data_001_max_size_gb              = "2"
sqldb_data_001_read_scale_enabled       = false
sqldb_data_001_sku_name                 = "Basic"
sqldb_data_001_zone_redundant_enabled   = false
sqldb_data_001_geo_backup_enabled       = true
sql_data_001_server_adminuserpassword   = "**************" # env specific
# stapp
stapp_region   = "East US 2"
stapp_sku_tier = "Free"
stapp_sku_size = "Free"