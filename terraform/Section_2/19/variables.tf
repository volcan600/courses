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