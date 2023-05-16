terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

# know account id
data "aws_caller_identity" "accountID" {

}

# know password and username 
data "aws_ecr_authorization_token" "token" {

}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.accountID.account_id}.dkr.ecr.us-east-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}