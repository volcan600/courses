# Terraform

## More than Certified in Terraform

### 21. Terraform State Deeper Dive
[State](https://www.terraform.io/docs/language/state/index.html)

```bash
terraform state list
```

```bash
terraform show -json | jq
```

### 22. Teraform Console and Outputs
* Use **terraform state list** to get all possible variables
* Use **terraform console** to test or find variables
* After launching terraform apply with outputs, use **terraform output** to get the output results


### 26. The Splat Expression

[Splat](https://www.terraform.io/docs/configuration/expressions.html#splat-expressions)

* Example

```tf
output "container_name" {
  value = docker_container.nodered_container[*].name
  description = "The name of the container"
}
```

### 30. Terraform Import
* This is helpful when you need to import a resource to the state file since terraform destroy does not work cause both terraform apply to the same tf file were applied to the same time launching double resources and the state file was currepted and some resources were outside of the state file.

[Import](https://www.terraform.io/docs/cli/import/index.html)
[Practice](https://learn.hashicorp.com/tutorials/terraform/state-import)

### 31. Terraform Refresh and State rm
* It is not good idea use refresh. It is an unsafe command, it won't display always the same output
* state rm usefult to remove resources from the state file

### 32. Adding Variables

```bash
# Example
variable "counter" {
  type = number
  default = 1
}
```

```bash
export TF_VAR_image_id=ami-abc123
terraform plan
```

```bash
unset TF_VAR_image_id
```

### 33. Variable Validation

```bash
variable "int_port" {
  type = number
  default = 1880
  
  validation {
    condition = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}
```

```bash
variable "ext_port" {
  type = number
  default = 1880
  
  validation {
    condition = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port mist be in the valid port range 0 - 65535."
  }
}
```