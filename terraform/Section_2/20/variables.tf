variable "apikey" {
    type = string
    sensitive = true
}

variable "apisecret" {
    type = string
    sensitive = true
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "instance" {
  type = string
  default = "t2.micro"
}

variable "vpc_ip" {
  type = string
  default = "201.191.5.27/32"
}