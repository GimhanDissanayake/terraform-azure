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

variable "appgw_subnet_id" {
  type        = string
  description = "Subnet to deploy the App Gateway."
}

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

variable "key_vault_id" {
  type        = string
  description = "key_vault_id."
}

variable "ssl_certificate_name" {
  type        = string
  description = "ssl_certificate_name."
}

variable "key_vault_secret_id" {
  type        = string
  description = "key_vault_secret_id."
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
