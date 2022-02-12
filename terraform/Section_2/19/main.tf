# Configure the AWS Provider
provider "aws" {
  region = var.region
  access_key = var.apikey
  secret_key = var.apisecret
}

# Resources
resource "aws_eip" "lb" {
  vpc       = true
}

resource "aws_s3_bucket" "mys3" {
  bucket    = "terraform-lab-demo-lesson19"
}

# outputs

output "eip" {
    value   = aws_eip.lb.public_ip 
}

output "mys3bucket" {
  value     = aws_s3_bucket.mys3.bucket_domain_name 
}
