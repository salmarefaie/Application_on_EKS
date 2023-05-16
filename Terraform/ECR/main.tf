# ECR repo
resource "aws_ecr_repository" "jenkins" {
  name = var.repo_name_ecr

  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}

# policy for delete untagged images
resource "aws_ecr_lifecycle_policy" "untagged_images_policy" {
  repository = aws_ecr_repository.jenkins.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# policy permisions for ECR
# resource "aws_ecr_repository_policy" "repo-policy" {
#   repository = aws_ecr_repository.jenkins.name
#   policy     = <<EOF
#   {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid": "Set the permission for ECR",
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:CompleteLayerUpload",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetLifecyclePolicy",
#           "ecr:InitiateLayerUpload",
#           "ecr:PutImage",
#           "ecr:UploadLayerPart"
#         ]
#       }
#     ]
#   }
#   EOF
# }

# build and push docker image
resource "docker_registry_image" "jenkins_image" {
  name = "${aws_ecr_repository.jenkins.repository_url}:latest"

  build {
    context    = var.context
    dockerfile = var.Dockerfile
  }
}