module "network" {
  source = "./network"

  vpc_cidr         = "10.0.0.0/16"
  vpc_name         = "vpc"
  internet_gateway = "internet gateway"
  nat_gateway      = "nat"
  eip              = "eip"
  public_cidr      = "0.0.0.0/0"

  public-subnet = {
    "public_subnet1" = { cidr = "10.0.0.0/24", zone = "us-east-1b" },
    "public_subnet2" = { cidr = "10.0.1.0/24", zone = "us-east-1c" }
  }

  private-subnet = {
    "private_subnet1" = { cidr = "10.0.2.0/24", zone = "us-east-1b" },
    "private_subnet2" = { cidr = "10.0.3.0/24", zone = "us-east-1c" }
  }

  route_table = {
    "public_name"  = "public route table",
    "private_name" = "private route table"
  }

  route = {
    "route1" = { routingTableID = module.network.public_route_table_id, gatewayID = module.network.gateway_id },
    "route2" = { routingTableID = module.network.private_route_table_id, gatewayID = module.network.nat_id }
  }

  subnet_association = {
    "publicSubnet_association1"  = { subnetID = module.network.public_subnet1_id, routingTableID = module.network.public_route_table_id },
    "publicSubnet_association2"  = { subnetID = module.network.public_subnet2_id, routingTableID = module.network.public_route_table_id },
    "privateSubnet_association1" = { subnetID = module.network.private_subnet1_id, routingTableID = module.network.private_route_table_id },
    "privateSubnet_association2" = { subnetID = module.network.private_subnet2_id, routingTableID = module.network.private_route_table_id }
  }
}


module "EKS" {
  source = "./EKS"

  cluster-role-name = "cluster-role"
  node-role-name    = "node-role"
  cluster-name      = "cluster"

  private-subnet1-id = module.network.private_subnet1_id
  private-subnet2-id = module.network.private_subnet2_id

  worker-nodes-name  = "worker-nodes"
  instance_type      = "t3.medium"
  key                = "EKS"
  capacity_type      = "ON_DEMAND"
  security_group_EKS = "EKS security group"
  vpcID              = module.network.vpc_id
  public_cidr        = "0.0.0.0/0"
  public_subnet_cidr = "10.0.1.0/24"
}


module "Ec2" {
  source             = "./Ec2"
  vpcID              = module.network.vpc_id
  ec2_type           = "t2.micro"
  subnet_id          = module.network.public_subnet2_id
  key_name           = "EKS"
  ec2_name           = "basion host"
  public_cidr        = "0.0.0.0/0"
  security_group_ec2 = "ec2 security group"
}


module "ECR" {
  source        = "./ECR"
  repo_name_ecr = "jenkins-image"
  context       = "../Jenkins-Deployment"
  Dockerfile    = "Dockerfile"
}