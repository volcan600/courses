provider "aws" {
  region = "us-east-1"
  access_key = var.apikey
  secret_key = var.secretkey
}

locals {
  common_tags = {
      Owner = "DevOps Team"
      service = "Backend"
  }
}

resource "aws_instance" "app-dev" {
  ami = "ami-0a8b4cd432b1c3063"
  instance_type = "t2.micro"
  tags = local.common_tags
}

resource "aws_instance" "db-dev" {
  ami = "ami-0a8b4cd432b1c3063"
  instance_type = "t2.micro"
  tags = local.common_tags
}

resource "aws_elb_volume" "db_ebs" {
  availability_zone = "us-east-1"
  size              = 8
  tags              = local.common_tags
}  