variable "tags" {
  type        = "map"
  description = "Map of tags"
}

variable "environment" {
  type        = "string"
  description = "Envrionment in which to run"
}

variable "aws_region" {
  type        = "string"
  description = "Region in which to run"
}

variable "vpc_name" {
  type = "string"
}

variable "vpc_cidr" {
  type = "string"
}

variable "subnet_names" {
  type = "list"
}

variable "subnet_cidrs" {
  type = "list"
}
