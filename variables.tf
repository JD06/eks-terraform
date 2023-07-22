variable "cidr_block" {
  type = string
  description = "VPC CIDR range"
  default = "10.0.0.0/16"
}

variable "project" {
  type = string
  description = "Project name to be used for the deployment and tagging the resources"
  default = "test"
}

variable "env" {
  type = string
  description = "Environment details e.g test, prod, etc..."
  default = "test"
}

variable "az_count" {
  type = number
  description = "Availability Zone"
  default = 3
}