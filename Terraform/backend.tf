# # at first comment backend code and run s3, s3 version, dynmo db or create from console .... terraform apply
# # then run backend code .... terraform init

resource "aws_s3_bucket" "state_file" {
  bucket = "terraform-state-file-task"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "s3_version" {
  bucket = aws_s3_bucket.state_file.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "lock_state" {
  name         = "lock-state-terraform"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# backend
terraform {
  backend "s3" {
    bucket         = "terraform-state-file-task"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lock-state-terraform"
    encrypt        = true
  }
}
