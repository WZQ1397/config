provider "aws" {
  region = "${aws.aws_region}"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  ami         = "${data.aws_ami.ubuntu.id}"
  server_text = "Hello, World"

  aws_region             = "${var.aws_region}"
  cluster_name           = "${var.cluster_name}"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 3
  enable_autoscaling = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-adm64-server-*"]
  }
}
