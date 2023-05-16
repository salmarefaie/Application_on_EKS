variable "cluster-role-name" {
  type        = string
  description = "name of cluster role"
}

variable "node-role-name" {
  type        = string
  description = "name of node role"
}

variable "cluster-name" {
  type        = string
  description = "name of cluster"
}

variable "private-subnet1-id" {
  type        = string
  description = "id of private subnet 1"
}

variable "private-subnet2-id" {
  type        = string
  description = "id of private subnet 2"
}

variable "worker-nodes-name" {
  type        = string
  description = "name of worker node"
}

variable "instance_type" {
  type        = string
  description = "type of instance for node worker"
}

variable "capacity_type" {
  type        = string
  description = "type of capacity for node worker"
}

variable "key" {
  type        = string
  description = "key"
}

variable "security_group_EKS" {
  type        = string
  description = "security group name for EKS"
}

variable "vpcID" {
  type        = string
  description = "vpc id"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "public_subnet_cidr" {
  type        = string
  description = "10.0.1.0/24"
}