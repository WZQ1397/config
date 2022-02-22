** In this case, we can use the aws_ami data source to obtain information about the most recent AMI image **

```css
that has the name prefix app-.

data "aws_ami" "app_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["app-*"]
  }
}
```
**Data sources export attributes, just like resources do. We can interpolate these attributes using the syntax data.TYPE.NAME.ATTR. In our example, we can interpolate the value of the AMI ID as  data.aws_ami.app_ami.id, and pass it as the ami argument for our aws_instance resource.**

```css
resource "aws_instance" "app" {
  ami           = "${data.aws_ami.app_ami.id}"
  instance_type = "t2.micro"
}
```

```
data "azurerm_virtual_machine" "example" {
  name                = "myVM"
  resource_group_name = "myResourceGroup"
}

output "virtual_machine_id" {
  value = data.azurerm_virtual_machine.example.id
}

# name - Specifies the name of the Virtual Machine.
# resource_group_name - Specifies the name of the resource group the Virtual Machine is located in.
```

```
data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name   = "name"
    values = ["HelloWorld"]
  }
}

resource "aws_instance" "app" {
  ami           = "${data.aws_ami.app_ami.id}"
  instance_type = "t2.micro"
}

# AWS Image named with "HelloWorld" must be there in your account.
```