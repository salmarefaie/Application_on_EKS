# cluster eks
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    subnet_ids = [
      var.private-subnet1-id,
      var.private-subnet2-id
    ]
    endpoint_private_access = true   
    endpoint_public_access  = true      # false
    security_group_ids      = [aws_security_group.EKS-sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]
}

# worker nodes
resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.worker-nodes-name
  node_role_arn   = aws_iam_role.node-role.arn

  subnet_ids = [
    var.private-subnet1-id,
    var.private-subnet2-id
  ]

  capacity_type  = var.capacity_type
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]

  remote_access {
    ec2_ssh_key = var.key
  }
}

# security group for EKS
resource "aws_security_group" "EKS-sg" {
  name        = var.security_group_EKS
  description = var.security_group_EKS
  vpc_id      = var.vpcID

  ingress {
    description = "access cluster by ec2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }

  tags = {
    Name = var.security_group_EKS
  }
}