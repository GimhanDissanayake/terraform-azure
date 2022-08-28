variable "stage" {
  type        = string
  description = "Environment."
}

variable "region" {
  type        = string
  description = "Operating Region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the resource."
}

variable "resource_name" {
  type        = string
  description = "Resource name where this resource is going to be used with."
}

variable "nsg_rules" {
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