variable "stage" {
  type        = string
  description = "Environment."
}

variable "stapp_region" {
  type        = string
  description = "Operating Region for the static web app."
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

variable "stapp_sku_tier" {
  type        = string
  description = "stapp_sku_tier."
}

variable "stapp_sku_size" {
  type        = string
  description = "stapp_sku_size."
}
