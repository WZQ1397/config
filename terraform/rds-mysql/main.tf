provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "my-tf-state"
        key = "prod/data-stores/mysql/terraform.tfstate"
        region = "eu-west-1"
        encrypt = true
    }
}

resource "aws_db_instance" "example" {
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "prod_example_database"
    username = "admin"
    password = "${var.db_password}"
}
