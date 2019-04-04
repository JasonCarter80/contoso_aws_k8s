# State Backend
terraform {
  backend "s3" {
    bucket         = "contoso-terraform-state"
    dynamodb_table = "contoso-terraform-locks"
    region         = "us-east-2"

    #encrypt        = true

    ### Change THIS!!!!   
    key = "resources/infra/kubernetes"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

