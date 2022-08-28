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

variable "vm_size" {
  type        = string
  description = "VM size."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to deploy the VM."
}

variable "source_image_publisher" {
  type        = string
  description = "source_image_publisher."
}

variable "source_image_offer" {
  type        = string
  description = "source_image_offer."
}

variable "source_image_sku" {
  type        = string
  description = "source_image_sku."
}

variable "source_image_version" {
  type        = string
  description = "source_image_sku."
}

variable "user_data_script" {
  type        = any
  description = "source_image_sku."
}
