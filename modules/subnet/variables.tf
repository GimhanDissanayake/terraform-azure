variable "stage" {
  type        = string
  description = "Environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the resource."
}

variable "vnet_name" {
  type        = string
  description = "Vnet name."
}

variable "subnet_address_prefixes" {
  type        = list(any)
  description = "Subnet address prefixes."
}

variable "subnet_name" {
  type        = string
  description = "Subnet name."
}