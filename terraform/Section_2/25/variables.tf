variable "apikey" {
    default = "aquielapikey"
    type = string
}

variable "apisecret" {
    default = "aquielsecret"
    type = string
}

variable "elb_names" {
    default = ["dev-loadbalancer", "stage-loadbalancer", "prod-loadbalancer"]
    type = list
}

