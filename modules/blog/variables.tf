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

variable "subnet_list" {
  type        = "list"
  description = "Subnet IDs across which to load balance"
}
