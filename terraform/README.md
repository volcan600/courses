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
* **terraform fmt** will check the format. If correct will print the files to check
* **terraform validate** Validate your configuration. The example configuration provided above is valid, so Terraform will return a success message.
* **terraform show** will show the current terraform.tfstate file
* **terraform state list** will list resources in your project's state

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

### 30. Debugging in Terraform
* ``export TF_LOG=TRACE`` to enable debug option. When run ``terraform plan`` will show debug
* Also, you can export the output to a file with the following variable ``export TF_LOG_PATH=/tmp/terraform-crash.log``

### 31. Terraform Format
* The ``terraform fmt`` command is used to rewrite Terraform configuation fules to take care of the overall formatting

### 32. Validating Terraform Configuration Files
* ``terraform validate`` primarily checks whether a configuration is syntactically valid

### 33. Load Order & Semantics
* Terraform generally loads all the configuration files within the directory specified in alphabetical order
* The files loaded must end in either .tf or .tf.json to specify the format that is in use.
  
### 34. Dynamic Blocks
* In many of the use-cases, there are repeatable nested blocks that needs to be defined.
* Dynamic blocks allows us to dynamically construct repatable nested blocks which is supported inside resource, data, provider, and provisioner blocks. example:
```bash
dynamic "ingress" {
  for_each = var.ingress_ports
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### 35. Taiting Resources
* You have created a new resource via Terraform
* Two ways to deal with this: Import the changes to Terraform / Delete & Recreate the resource
* The terraform taint command manually marks a Terraform-managed resource as tainted, forcing it to be destroyed and recreated on the next apply
* ``terraform taint aws_instance.myec2`` 

### 36. Splat Expressions
* Splat Expression allows us to get a list of all the attributes
```yaml 
resource "aws_iam_user" "lb" {
  name = "iamuser.${count.index}"
  count = 3
  path = "/system/"
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}
```

### 37. Terraform Graph
* The **terraform graph** command is used to generate a visual representation of either a configuration or execution plan
* The output of terraform graph is in the DOT format, which can easily be converted to an image.
* Example: ``terraform graph > graph.dot`` It will convert to test, you can also use an additional tool to convert to nice graph(graphviz - Graph Visualization Software)
* ``cat graph.dot | dot -Tsvg > graph.svg``

### 38. Saving Terraform Plan to File
* The generated terraform plan can be saved to a specific path
* To generate``terraform plan -out=path`` 
* To apply using path ``terraform apply demopath``

### 39. Terraform Output
* The terraform output command is used to extract the value of an output variable from the state file
* Example:
``terraform output iam_name``

### 40. Terraform Settings
* terraform version
```json
terraform {
  required_version = ">.12.0"
}
```
* provider version
```
terraform {
  required_providers {
    mycloud = {
      source = "mycorp/mycloud
      version = "~> 1.0"
    }
  }
}
```

### 41. Dealing with Large Infrastructure
* switch to smaller configuration were each canbe applied independently
* We can prevent terraform form querying the current state during operations like terraform plan. This can be achieved with the ``-refresh=false`` flag
``terraform plan -refresh=false -target=aws_security_group.allow_ssh_con``

### 42. Zipmap Function
* The zipmap function constructs a map from a list of keys and a corresponding list of values.
* Example:
```
zipmap(["pineapple","orange","strawberry"],["yellow","orange","red"])
{
  "oranges" = "orange"
  "pineapple" = "yewllo"
  "strawberry" = "red"
}
```

### 45. Types of Provisioners
* Terraform has capability to turn provisioners both at the time of resource creation as well as destruction.
* Types: local-exec/remote-exec
* local-exec provisioners allow us to invoke local executable after resource is created
```
resource "aws_instance" "web" {
  #...

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} >> private_ips.txt"
  }
}
```
* Remote-exec provisioners allow to invoke scripts directly on the remote server
```
resource "aws_instance" "web" {
  provisioner "remote-exec"{

  }
}
```

### 47. Implementing local-exec provisioners
* local-exec provisioners allows us to invoke a local executable after the resource is created
* One of the most used approach of local-exec is to run ansible-playbooks on the created server after the resource is created

### 48. Creation-Time & Destroy-Time Provisioners
* There are two primary types of provisioners:
* Creation-Time Provisioner: Creation-time provisioners are only run during creation, not during updating or any other lifecycle. **If a creation-time provisioner fails, the resource is marked as tainted**
* Destroy-Time Provisioner: Destroy provisioners are run before the resource is destroyed.
```
resource "aws_instance" "web" {
  #.....

  provisioner "local-exec" {
    when = destroy
    command = "echo 'Destroy-time provisioner'"
  }
}
```

### 49. Failure Behavior for Provisioners
* By default, provisioners that fail will also cause the Terraform apply itself to fail.
* The **on_failure** setting can be used to change this. The allowed values are
* continue: Ignore and continue with creation or destruction
* fail: Raise an error and stop applying (the default behavior). If this is a creation provisioner, taint the resource.


### 51. Understanding DRY principle
* In software engineering, don't repeat yourself(DRY) is a principle of software development aimed at reducing repetition of software patterns
* In the earlier lecture, we were making static content into variables so that there can be single source of information
* Use module as reference

### 54. Terraform Registry
* The Terraform Registry is a repository of modules written by the Terraform community. The registry can help you get started with Terraform more quickly

### 55. Terraform Workspace
* Terraform allows us to have multiple workspaces, with each of the workspace we can have different set of environment variables associated
* **terraform workspace -h**/**terraform workspace**/**terraform workspace list**/ **terraform workspace select dev**

### 58. Integrating with GIT for team management
* Local changes are not always good
* Use github, bitbucket, gitlab to store .tf files except sensible ones
  
### 60. Security Challenges in Commiting TFState to GIT
* Never store secret or sensible information on git cloud providers

### 61. Module Sources in Terraform
* The source argument in a module block tells Terraform where to find the source code for the desired child module

### 62. Terraform and .gitignore
* Terraform and .gitignore. Files to ignore: .terraform, terraform.tfvars, terraform.tfstate, crash.log 

### 64. Implementing S3 Backend
* Store terraform.tstate file in cloud 

### 65. Challenges with State File locking
* This is very important as otherwise during your ongoing terraform apply operations, if others also try for the same, it would corrupt your state file

### 66. Integrating DynamoDB with S3 for state locking
* it is necesary to implement locking in case two terraform apply ran simultaneously. So the resource will lock until the first task is completed

### 67. Terraform State Management
* It is important to never modify the state file directly. Instead, make use of terraform state command.
* sub command: list, mv(useful to rename existing resource without destroying and recreating it), pull, push, rm and show

### 68. Importing Existing Resources with Terraform Import
* terraform import <resource> <id>

### 70. Handling Access & Secret Keys the Right Way in Providers
* NEVER store any sensible secret on terraform files

### 74. Sensitive Parameter
* Setting the sensitive to "true" will prevent the field's values from showing up in CLI output and in Terraform Cloud
  
### 76. Overview of Terraform Cloud
* Terraform Cloud manages, Terraform runs in a consistent and reliable environment with various features like access controls, private registry for sharing modules,policy controls and others.

### 77. Creating Infrastructure with Terraform Cloud
* Explore terraform cloud

### 79. Overview of Sentinel
* Sentinel is an embedded policy-as-code framework integrated with the HashiCorp Enterprise products.
* It enables fine-grained, logic-based decisions, and can be extended to use information from external sources
* terraform plan > sentinel checks > terraform apply
* terraform cloud trial should be enable to have access to policies

### 80. Overview of Remote Backends
* The remote backend stores Terraform state and may be used to run operations in Terraform Cloud.
