variable "stage" {
  type        = string
  description = "Environment."
}

variable "region" {
  type        = string
  description = "Operating Region."
}

variable "instance" {
  type        = string
  description = "Instance of the resource."
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the resource."
}

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
