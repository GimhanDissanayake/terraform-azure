resource "azurerm_mssql_server" "sql_server" {
  name                          = join("-", ["sql", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  resource_group_name           = var.resource_group_name
  location                      = var.region
  version                       = var.sql_server_version
  administrator_login           = var.sql_server_adminusername
  administrator_login_password  = var.sql_server_adminuserpassword
  minimum_tls_version           = var.sql_server_minimalTlsVersion
  public_network_access_enabled = var.sql_server_publicnetworkaccess

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env = var.stage
  }
}

resource "azurerm_mssql_firewall_rule" "sql_firewall_rule" {
  name             = "AllowAccesstoAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "sqldb" {
  name               = join("-", ["sqldb", var.project, var.stage, replace(lower(var.region), " ", ""), var.instance])
  server_id          = azurerm_mssql_server.sql_server.id
  collation          = "SQL_Latin1_General_CP1_CI_AS" # a set of character and character encoding rules
  max_size_gb        = var.sqldb_max_size_gb
  read_scale         = var.sqldb_read_scale_enabled
  sku_name           = var.sqldb_sku_name
  zone_redundant     = var.sqldb_zone_redundant_enabled
  geo_backup_enabled = var.sqldb_geo_backup_enabled

  tags = {
    env = var.stage
  }
}

