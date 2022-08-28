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

variable "aks_sku" {
  type        = string
  description = "AKS sku to use."
}

variable "subnet_id" {
  type        = string
  description = "Subnet id to deploy the kubernetes nodes."
}

variable "subnet_name" {
  type        = string
  description = "Subnet name to deploy the kubernetes nodes."
}

variable "appgw_id" {
  type        = string
  description = "App gateway loadbalancer id for the APIC configuration."
}

variable "logaw_id" {
  type        = string
  description = "Log analytics workspace ID."
}

variable "acr_id" {
  type        = string
  description = "Id of acr use with aks cluster."
}

variable "aapgw_id" {
  type        = string
  description = "Id of aapgw use with aks cluster APIC."
}

variable "main_rg_id" {
  type        = string
  description = "Id of main resource group which contain all resources."
}

variable "aapgw_managed_identity_id" {
  type        = string
  description = "Id of aapgw_managed_identity_id use."
}

variable "default_node_pool_size" {
  type        = string
  description = "default_node_pool_size"
}

