variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "internet_gateway" {
  type        = string
  description = "internet gateway name"
}

variable "public-subnet" {
  type        = map(any)
  description = "public subnets"
}

variable "private-subnet" {
  type        = map(any)
  description = "private subnets"
}

variable "nat_gateway" {
  type        = string
  description = "nat gateway name"
}

variable "eip" {
  type        = string
  description = "eip name"
}

variable "route_table" {
  type        = map(any)
  description = "route table"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "route" {
  type        = map(any)
  description = "route for route table"
}


variable "subnet_association" {
  type        = map(any)
  description = "route for route table"
}