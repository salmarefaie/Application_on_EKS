variable "ec2_type" {
  type        = string
  description = "instance type"
}

variable "subnet_id" {
  type        = string
  description = "id for basion host subnet"
}

variable "key_name" {
  type        = string
  description = "name of key"
}

variable "ec2_name" {
  type        = string
  description = "name of ec2"
}

variable "vpcID" {
  type        = string
  description = "vpc id"
}

variable "enable_publicIP" {
  type        = bool
  description = "true"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "security_group_ec2" {
  type        = string
  description = "security group name for ec2"
}