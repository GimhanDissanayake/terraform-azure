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

variable "project_short" {
  type        = string
  description = "Project short name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the resource."
}