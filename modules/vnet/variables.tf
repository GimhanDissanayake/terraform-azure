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

variable "vnet_address_spaces" {
  type        = list(any)
  description = "Vnet address space."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the resource."
}

# variable "pvt_sn_1_address_space" {
#   type        = string
#   description = "Private subnet address space."
# }

# variable "appgw_sn_1_address_space" {
#   type        = string
#   description = "App gateway loadbalancer subnet address space."
# }

# variable "pvt_endpoints_sn_1_address_space" {
#   type        = string
#   description = "Private endpoint subnet address space."
# }