variable "repo_name_ecr" {
  type        = string
  description = "name of ECR repo"
}

variable "context" {
  type        = string
  description = "path for dockerfile"
}

variable "Dockerfile" {
  type        = string
  description = "dockerfile name"
}