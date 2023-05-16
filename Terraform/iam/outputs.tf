output "cluster-role-arn" {
  value = aws_iam_role.clusrter-role.arn
}

output "cluster-policy" {
  value = aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
}

output "node-role-arn" {
  value = aws_iam_role.node-role.arn
}

output "node-policy" {
  value = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
}

output "container-policy" {
  value = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
}

output "cni-policy" {
  value = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
}

output "noderole" {
  value = aws_iam_role.node-role.name
}