# Resource group
module "resource_group_001" {
  source   = "../../modules/rg"
  stage    = var.stage
  project  = var.project
  region   = var.region
  instance = "001"
}

# Vnet and Subnets
module "vnet_001" {
  source              = "../../modules/vnet"
  stage               = var.stage
  project             = var.project
  region              = var.region
  instance            = "001"
  vnet_address_spaces = var.vnet_address_spaces
  resource_group_name = module.resource_group_001.resource_group_name
}

module "pub_sn_1" {
  source                  = "../../modules/subnet"
  stage                   = var.stage
  resource_group_name     = module.resource_group_001.resource_group_name
  vnet_name               = module.vnet_001.vnet_name
  subnet_address_prefixes = var.pub_sn_1_address_prefixes
  subnet_name             = join("-", [module.vnet_001.vnet_name, "pub-sn-1"])
}

module "nsg_for_pub_sn_1" {
  source              = "../../modules/nsg"
  stage               = var.stage
  region              = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  resource_name       = module.pub_sn_1.subnet_name
  nsg_rules           = var.pub_sn_1_nsg_rules
}

resource "azurerm_subnet_network_security_group_association" "nsg_pub_sn_1_association" {
  subnet_id                 = module.pub_sn_1.subnet_id
  network_security_group_id = module.nsg_for_pub_sn_1.nsg_id
}

module "pvt_sn_1" {
  source                  = "../../modules/subnet"
  stage                   = var.stage
  resource_group_name     = module.resource_group_001.resource_group_name
  vnet_name               = module.vnet_001.vnet_name
  subnet_address_prefixes = var.pvt_sn_1_address_prefixes
  subnet_name             = join("-", [module.vnet_001.vnet_name, "pvt-sn-1"])
}

module "nsg_for_pvt_sn_1" {
  source              = "../../modules/nsg"
  stage               = var.stage
  region              = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  resource_name       = module.pvt_sn_1.subnet_name
  nsg_rules           = var.pvt_sn_1_nsg_rules
}

resource "azurerm_subnet_network_security_group_association" "nsg_pvt_sn_1_association" {
  subnet_id                 = module.pvt_sn_1.subnet_id
  network_security_group_id = module.nsg_for_pvt_sn_1.nsg_id
}

module "appgw_sn_1" {
  source                  = "../../modules/subnet"
  stage                   = var.stage
  resource_group_name     = module.resource_group_001.resource_group_name
  vnet_name               = module.vnet_001.vnet_name
  subnet_address_prefixes = var.appgw_sn_1_address_prefixes
  subnet_name             = join("-", [module.vnet_001.vnet_name, "appgw-sn-1"])
}

module "pvt_endpoints_sn_1" {
  source                  = "../../modules/subnet"
  stage                   = var.stage
  resource_group_name     = module.resource_group_001.resource_group_name
  vnet_name               = module.vnet_001.vnet_name
  subnet_address_prefixes = var.pvt_endpoints_sn_1_address_prefixes
  subnet_name             = join("-", [module.vnet_001.vnet_name, "pvt-endpoints-sn-1"])
}

# log analytics workspace
module "logaw_001" {
  source              = "../../modules/logaw"
  stage               = var.stage
  project             = var.project
  region              = var.region
  instance            = "001"
  resource_group_name = module.resource_group_001.resource_group_name
}

# acr
module "acr_001" {
  source              = "../../modules/acr"
  stage               = var.stage
  project             = var.project
  region              = var.region
  instance            = "001"
  resource_group_name = module.resource_group_001.resource_group_name
}

resource "azurerm_private_dns_zone" "acr_pvt_dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = module.resource_group_001.resource_group_name

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_pvt_dns_zone_vnet_link" {
  name                  = "acr_pvt_dns_zone_vnet_link"
  resource_group_name   = module.resource_group_001.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_pvt_dns_zone.name
  virtual_network_id    = module.vnet_001.vnet_id

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_endpoint" "acr_001_pvt_endpoint" {
  name                = join("", ["acr", title(var.project), title(var.stage), title(replace(lower(var.region), " ", "")), "001", "pvt-endpoint"])
  location            = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  subnet_id           = module.pvt_endpoints_sn_1.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_pvt_dns_zone.id]
  }

  private_service_connection {
    name                           = join("", ["acr", title(var.project), title(var.stage), title(replace(lower(var.region), " ", "")), "001"])
    private_connection_resource_id = module.acr_001.acr_id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  tags = {
    env = var.stage
  }
}

# Application Gateway Loadbalancer
module "appgw_001" {
  source                    = "../../modules/appgw"
  stage                     = var.stage
  project                   = var.project
  region                    = var.region
  instance                  = "001"
  resource_group_name       = module.resource_group_001.resource_group_name
  appgw_subnet_id           = module.appgw_sn_1.subnet_id
  appgw_frontend_private_ip = var.appgw_frontend_private_ip
  appgw_sku_name            = var.appgw_sku_name
  appgw_sku_tier            = var.appgw_sku_tier
  appgw_sku_capacity        = var.appgw_sku_capacity
  appgw_zones               = var.appgw_zones
  key_vault_id              = module.kv_001.kv_id
  ssl_certificate_name      = join("-", [var.kv_ssl_cert_prefix, var.project, var.stage, "001"])
  key_vault_secret_id       = azurerm_key_vault_certificate.import_cert_to_kv_001.secret_id
  appgw_waf_enabled         = var.appgw_waf_enabled
  appgw_waf_mode            = var.appgw_waf_mode
  appgw_waf_ruleset_type    = var.appgw_waf_ruleset_type
  appgw_waf_ruleset_version = var.appgw_waf_ruleset_version
}

# Bastion Server
data "template_file" "user_data_script" {
  template = file("../../scripts/bastion_userdata.sh")
}

module "bastion_server_001" {
  source                 = "../../modules/linux_vm"
  stage                  = var.stage
  project                = var.project
  region                 = var.region
  instance               = "bastion-001"
  resource_group_name    = module.resource_group_001.resource_group_name
  vm_size                = var.vm_size
  subnet_id              = module.pub_sn_1.subnet_id
  source_image_publisher = var.source_image_publisher
  source_image_offer     = var.source_image_offer
  source_image_sku       = var.source_image_sku
  source_image_version   = var.source_image_version
  user_data_script       = base64encode(data.template_file.user_data_script.rendered)
}

module "nsg_for_bastion_server" {
  source              = "../../modules/nsg"
  stage               = var.stage
  region              = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  resource_name       = module.bastion_server_001.name
  nsg_rules           = var.bastion_nsg_rules
}

resource "azurerm_network_interface_security_group_association" "nsg_bastion_server_association" {
  network_interface_id      = module.bastion_server_001.nic_id
  network_security_group_id = module.nsg_for_bastion_server.nsg_id
}

# aks cluster
module "aks_001" {
  source                    = "../../modules/aks"
  stage                     = var.stage
  project                   = var.project
  region                    = var.region
  instance                  = "001"
  resource_group_name       = module.resource_group_001.resource_group_name
  aks_sku                   = var.aks_sku
  subnet_id                 = module.pvt_sn_1.subnet_id
  subnet_name               = module.pvt_sn_1.subnet_name
  appgw_id                  = module.appgw_001.appgw_id
  logaw_id                  = module.logaw_001.logaw_id
  acr_id                    = module.acr_001.acr_id
  aapgw_id                  = module.appgw_001.appgw_id
  main_rg_id                = module.resource_group_001.resource_group_id
  aapgw_managed_identity_id = module.appgw_001.appgw_managed_identity_id
  default_node_pool_size    = var.default_node_pool_size
}

# Key vault
module "kv_001" {
  source              = "../../modules/kv"
  stage               = var.stage
  project_short       = var.project_short
  region              = var.region
  instance            = "001"
  resource_group_name = module.resource_group_001.resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "tf_admin_access_policy" {
  key_vault_id = module.kv_001.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  certificate_permissions = [
    "Get", "Import", "Recover", "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "kubelet_identity_access_policy" {
  key_vault_id = module.kv_001.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.aks_001.kubelet_identity_object_id

  secret_permissions = [
    "Get",
    "List",
  ]
  
}

# Set 60s wait
resource "null_resource" "previous" {}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "60s"
}

resource "azurerm_key_vault_certificate" "import_cert_to_kv_001" {
  name         = join("-", [var.kv_ssl_cert_prefix, var.project, var.stage, "001"])
  key_vault_id = module.kv_001.kv_id

  certificate {
    contents = filebase64(var.ssl_cert_file_location)
    password = ""
  }

  # The user excecuting the tf template needs to have GetCertificate access to the kv
  depends_on = [
    azurerm_key_vault_access_policy.tf_admin_access_policy, time_sleep.wait_60_seconds
  ]
}

resource "azurerm_private_dns_zone" "kv_pvt_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = module.resource_group_001.resource_group_name

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_pvt_dns_zone_vnet_link" {
  name                  = "kv_pvt_dns_zone_vnet_link"
  resource_group_name   = module.resource_group_001.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv_pvt_dns_zone.name
  virtual_network_id    = module.vnet_001.vnet_id

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_endpoint" "kv_001_pvt_endpoint" {
  name                = join("-", ["kv", var.project_short, var.stage, replace(lower(var.region), " ", ""), "001", "pvt-endpoint"])
  location            = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  subnet_id           = module.pvt_endpoints_sn_1.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_pvt_dns_zone.id]
  }

  private_service_connection {
    name                           = join("-", ["kv", var.project_short, var.stage, replace(lower(var.region), " ", ""), "001"])
    private_connection_resource_id = module.kv_001.kv_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = {
    env = var.stage
  }
}

# sqldb
module "sqldb_001" {
  source                         = "../../modules/sqldb"
  stage                          = var.stage
  project                        = var.project
  region                         = var.region
  instance                       = "001"
  resource_group_name            = module.resource_group_001.resource_group_name
  sql_server_version             = var.sql_server_version
  sql_server_adminusername       = var.sql_server_adminusername
  sql_server_adminuserpassword   = var.sql_server_adminuserpassword
  sql_server_minimalTlsVersion   = var.sql_server_minimalTlsVersion
  sql_server_publicnetworkaccess = var.sql_server_publicnetworkaccess
  sqldb_max_size_gb              = var.sqldb_max_size_gb
  sqldb_read_scale_enabled       = var.sqldb_read_scale_enabled
  sqldb_sku_name                 = var.sqldb_sku_name
  sqldb_zone_redundant_enabled   = var.sqldb_zone_redundant_enabled
  sqldb_geo_backup_enabled       = var.sqldb_geo_backup_enabled
}

module "sqldb_data_001" {
  source                         = "../../modules/sqldb"
  stage                          = var.stage
  project                        = var.project
  region                         = var.region
  instance                       = "data-001"
  resource_group_name            = module.resource_group_001.resource_group_name
  sql_server_version             = var.sql_data_001_server_version
  sql_server_adminusername       = var.sql_data_001_server_adminusername
  sql_server_adminuserpassword   = var.sql_data_001_server_adminuserpassword
  sql_server_minimalTlsVersion   = var.sql_data_001_server_minimalTlsVersion
  sql_server_publicnetworkaccess = var.sql_data_001_server_publicnetworkaccess
  sqldb_max_size_gb              = var.sqldb_data_001_max_size_gb
  sqldb_read_scale_enabled       = var.sqldb_data_001_read_scale_enabled
  sqldb_sku_name                 = var.sqldb_data_001_sku_name
  sqldb_zone_redundant_enabled   = var.sqldb_data_001_zone_redundant_enabled
  sqldb_geo_backup_enabled       = var.sqldb_data_001_geo_backup_enabled
}

resource "azurerm_private_dns_zone" "sqldb_pvt_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = module.resource_group_001.resource_group_name

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "sqldb_pvt_dns_zone_vnet_link" {
  name                  = "sqldb_pvt_dns_zone_vnet_link"
  resource_group_name   = module.resource_group_001.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sqldb_pvt_dns_zone.name
  virtual_network_id    = module.vnet_001.vnet_id

  tags = {
    env = var.stage
  }
}

resource "azurerm_private_endpoint" "sqldb_001_pvt_endpoint" {
  name                = join("-", ["sqldb", var.project, var.stage, replace(lower(var.region), " ", ""), "001", "pvt-endpoint"])
  location            = var.region
  resource_group_name = module.resource_group_001.resource_group_name
  subnet_id           = module.pvt_endpoints_sn_1.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sqldb_pvt_dns_zone.id]
  }

  private_service_connection {
    name                           = join("-", ["sqldb", var.project, var.stage, replace(lower(var.region), " ", ""), "001"])
    private_connection_resource_id = module.sqldb_001.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["SqlServer"]
  }

  tags = {
    env = var.stage
  }
}

# stapp
module "stapp_001" {
  source              = "../../modules/stapp"
  stage               = var.stage
  project             = var.project
  stapp_region        = var.stapp_region
  instance            = "001"
  resource_group_name = module.resource_group_001.resource_group_name
  stapp_sku_tier      = var.stapp_sku_tier
  stapp_sku_size      = var.stapp_sku_size
}