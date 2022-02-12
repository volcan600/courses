# Configure the AWS Provider
provider "aws" {
  region = var.region
  access_key = var.apikey
  secret_key = var.apisecret
}

# Resources
resource "aws_instance" "myec2" {
  ami = "ami-08e4e35cccc6189f4"
  instance_type = var.instance
}

resource "aws_eip" "lb" {
  vpc       = true
}

resource "aws_s3_bucket" "mys3" {
  bucket    = "terraform-lab-demo-lesson19"
}

# Associate elastic IP and instance
resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

resource "aws_security_group" "allow_tls" {
  name      = "abacus-security-group"

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [var.vpc_ip]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [var.vpc_ip]
  }
}

