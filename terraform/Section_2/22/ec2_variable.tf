provider "aws" {
    region = "us-west-2"
    access_key = "keypi"
    secret_key = "secretpi"
}

resource "aws_instance" "myec2" {
  ami = "ami-08e4e35cccc6189f4"
  instance_type = var.instancetype
}