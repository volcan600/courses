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

