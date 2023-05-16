variable "cluster-name" {
  type        = string
  description = "name of cluster"
}

variable "cluster-role-arn" {
  type        = string
  description = "arn of cluster role"
}

variable "private-subnet1-id" {
  type        = string
  description = "id of private subnet 1"
}

variable "private-subnet2-id" {
  type        = string
  description = "id of private subnet 2"
}

variable "policy-cluster" {
  type        = any
  description = "policy of eks cluster"
}

variable "worker-nodes-name" {
  type        = string
  description = "name of worker node"
}

variable "node-role-arn" {
  type        = string
  description = "arn of node role"
}

variable "policy-container-readonly" {
  type        = any
  description = "policy of container read only"
}

variable "policy-CNI" {
  type        = any
  description = "policy of cni"
}

variable "policy-node" {
  type        = any
  description = "policy of node"
}

variable "endpoint" {
  type        = bool
  description = "true"
}

variable "instance_type" {
  type        = string
  description = "type of instance for node worker"
}

variable "key" {
  type        = string
  description = "key"
}

variable "capacity_type" {
  type        = string
  description = "type of capacity for node worker"
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