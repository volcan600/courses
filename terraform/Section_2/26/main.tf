provider "aws" {
    region = "us-east-1"
    access_key = var.apikey  
    secret_key = var.secretkey
}

variable "istest" {}

resource "aws_instance" "dev" {
    ami = "ami-0a8b4cd432b1c3063"
    instance_type = "t2.micro"
    count = var.istest == true ? 1 : 0
}

resource "aws_instance" "prod" {
    ami = "ami-0a8b4cd432b1c3063"
    instance_type = "t2.large"
    count = var.istest == false ? 1 : 0
}