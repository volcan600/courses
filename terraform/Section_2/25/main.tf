terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.apikey
  secret_key = var.apisecret
}

provider "aws_iam_user" "lb" {
  name  = var.elb_names[count.index]
  count = 3
  path  = "/system"
}