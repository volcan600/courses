# Terraform

### 12. Destroy Infrastructure with Terraform
* Resources can destrou with the following command
```bash
terraform destroy
```
* Destroy specific resources, combination of: Resource Type + Local Resource Name
```bash
terraform destroy -target aws_instance.myec2
```
### 13. Understanding Terraform State files
* Terraform stores the state of the infrastructure that is being created from the TF files
  
### 14. Understanding Desired & Current States
* Desired State: Terraform's primary function is to create, modify, and destroy infrastructre resources to match the desired state described in a Terraform configuration
* Current State: Current state is the actual state of a resource that is currently deployed


### 16. Terraform Provider Versioning
* Provider plugins are released separetly from Terraform itself
* During terraform init, if version argument is not specified, the most recent provider will be downloaded during initialization
* if the terraform.lock.hl existe contains the version
* Run the following to upgrade a terraform version
* Destroy specific resources, combination of: Resource Type + Local Resource Name
```bash
terraform init -upgrade
```

### 18. Overview of Course Lecture Format
* Good practice to create a directory for each project or demo
* It is good practice store code in a repository
* Always destroy resources for a practical to avoid charges. For production do not use destroy or auto-approval

### 19. Understanding Atributes and Output Values in Terraform
* Terraform has capability to output the attribute of a resource with the output values
* An outputed attributes can not only be used for the user refence but it can also act as a input to other resources being created via terraform

### 20. Referencing Cross-Account Resource Attributes
* An outputed attributes can not only be used for the user reference but it can also act as a input to other resources being created via terraform

### 21. Terraform Variables
* Avoid reapeated static values can create more work in the future
* variables are good, we can have a central source from which we can import the values from

### 22. Approaches for Variable Assignment
* Variables can be defined on variables.tf file
* Also variables cam be defined terraform plan -var="instancetype=t2.small"
```bash
terraform plan -var-file="terraform.tfvars"
```
* another way to create variables, similar way than language program like python. Example, see folder 22
* It is possible to pass the terraform variables file using the following option
```bash
terraform plan -var-file="terraform.tfvars"
```
* Another one, use the TF_VAR in the shell
```bash
export TF_VAR_instancetype="m5.large"
```
* If you use echo for the variable content, you wont be able to see the variable. However,

### 23. Data Types Variables
* The type argument in a variable block allows you to restrict the type of value that will be accepted as the value for a variable
* It is good practice always specify the type for each variable
* Example:
```yaml
variable "instancetype" {
  default = "t2.micro"
  type = string
}
```
|**Type Keywords**|**Description**                                                                                       |
| String          | Sequence of Unicode characters representing some text, like "hello".                                 |
| list            | Sequential list of values identified by their position. Starts with 0 ["mumbai", "singapore", "usa"] |
| map             | A group of values indenfied by named labels, like {name = "Mabel", age = 52}                         |
| number          | Example: 200                                                                                         |

### 24. Fetching Data from Maps and List in Variable
* Example:
```tf
resource "aws_instance" "myec2" {
  ami = "ami-484389438484f"
  instance_type = var.list[0]
}
```

### 25. Count and Count Index
* The count parameter on resources can simplify configurations and let you scale resources by simply incrementing a number.
* Example:
```bash
provider "aws_instance" "instance-1" {
  ami = "ami-0a8b4cd432b1c3063"
  instance_type = "t2.micro"
  count = 3
}
```
* The count index in resource blocks where count is set, an additional count object is available in expressions, so you can modify the configuration of each instance
* count.index allows us to fetch the index of each iteration in the loop
* Example:
```bash
provider "aws_iam_user" "lb" {
  name  = "loadbalancer.${count.index}"
  count = 5
  path  = "/system"
}
```
* For easy convetion name, you can use variables
```bash
variable "elb_names" {
    default = ["dev-loadbalancer", "stage-loadbalancer", "prod-loadbalancer"]
    type = list
}

provider "aws_iam_user" "lb" {
  name  = var.elb_names[count.index]
  count = 3
  path  = "/system"
}
```

### 26. Conditional Expressions
* A conditional expression uses the value of a bool expression to select one of two values
* Syntax: **condition ? true_val : false_val**
* Example:
```bash
resource "aws_instance" "dev" {
    ami = "ami-0a8b4cd432b1c3063"
    instance_type = "t2.micro"
    count = var.istest == true ? 1 : 0
}
```

### 27. Local Values
* A local value assings a name to an expression, allowing it to be used multiple times within a module without repeating it
* Example:
```bash
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
```
* Local values can be used for multiple different use-cases like having a conditional expression
* Example:
```bash
local {
  name_prefix = "${var.name !+ "" ? var.name : var.default}"
}
```

### 28. Terraform Functions
* The Terraform language includes a number of built-in functions that you can use to transform and combine values.
* The general syntax for functions calls is a function name followed by comma-separated arguments in parentheses:
* **function(argument1,argument2)**
* Example:
```bash
max(5, 12, 9)
```
* The terraform language does not support user-defined functions, and so only the functinos built in to the language are available for use
  * Numeric
  * String
  * Collection
  * Encoding
  * Filesystem
  * Data and Time
  * Hash and Crypto
  * IP Network
  * Type Conversion
* **terraform console** command is helpful to test functions
* [Terraform function documentation](https://www.terraform.io/language/functions)
