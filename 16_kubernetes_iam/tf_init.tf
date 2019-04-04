# State Backend
terraform {
  backend "s3" {
    bucket         = "contoso-terraform-state"
    dynamodb_table = "contoso-terraform-locks"
    region         = "us-east-2"

    #encrypt        = true

    ### Change THIS!!!!   
    key = "resources/infra/kubernetes-iam"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}


locals {
  base_workspace = "${join("-", slice(split("-", terraform.workspace), 0, 4))}"
}

data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config {
    bucket = "contoso-terraform-state"
    key    = "resources/infra/kubernetes"
    region = "us-east-2"
  }

  workspace = "${local.base_workspace}"
}