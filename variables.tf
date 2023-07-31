variable "region" {
  type = string
}

variable "vpc" {
  type = list(any)
}

variable "environment" {
  type = string
}

variable "public_subnets" {
  type = list(any)
}

variable "private_subnets" {
  type = list(any)
}

variable "igw_name" {
  type = string
}

variable "public_subnet_route_tables" {
  type = list(any)
}

variable "private_subnet_route_tables" {
  type = list(any)
}

variable "PublicInstances" {
  type = list(any)
}

variable "public_security_group_rules" {
  type = list(any)
}

variable "public_security_groups" {
  type = list(any)
}


variable "ecsclusters" {
  type = list(any)
}

variable "taskdefs" {
  type = list(any)
}

variable "ecsServices" {
  type = list(any)
}