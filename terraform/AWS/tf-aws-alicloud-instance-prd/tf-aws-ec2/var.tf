variable "ami" {
  description = "Zach-CentOS7.5"
  default = "ami-0666d339a1600a343"
}
variable "type" {
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "key" {
  description = "IAM key string"
  default = "tongshan"
}

variable "PATH_TO_PRIVATE_KEY" {
  description = "IAM key path"
  default = "./tongshan.pem"
}

variable "region" {
  description = "availiable zone"
  default = "cn-north-1a"
}

variable "subnet-id" {
  description = "subnet belong for vpc"
  default = "subnet-0544b0c58ebc522e9"
}

variable "PriIP" {
  description = "private ip list"
  type = "map"
  default = {
    "0" = "172.10.101.101"
    "1" = "172.10.101.102"
    "2" = "172.10.101.103"
    "3" = "172.10.101.104"
    "4" = "172.10.101.105"
    "5" = "172.10.101.106"
    "6" = "172.10.101.107"
  }
}

variable "ebs" {
  description = "ebs volume config"
  type = "map"
  default = {
    device_name = "/dev/xvdf"
    volume_type = "st1"
    volume_size = "500"
  }
}

variable "prd-sg-def" {
  description = "prd security group"
  type = "map"
  default = {
    basic = "sg-0811c2195e464b0cd"
    monitor ="sg-03a1c61dbf8cb0fda"
    web = "sg-02c790d61128e795a"
    MQ = "sg-0eeb6eebbf8665a17"
    db = "sg-0920335259330ea50"
    ServiceMesh = "sg-00da02b0b5ed70847"
  }
}

variable "dev-sg-def" {
  description = "dev security group"
  type = "map"
  default = {
//    basic = "sg-0811c2195e464b0cd"
//    monitor ="sg-03a1c61dbf8cb0fda"
//    web = "sg-02c790d61128e795a"
//    MQ = "sg-0eeb6eebbf8665a17"
//    db = "sg-0920335259330ea50"
//    ServiceMesh = "sg-00da02b0b5ed70847"
  }
}


variable "vpc" {
  description = "set prd or dev vpc id"
  type = "map"
  default = {
    dev = "vpc-6e8e5a0b"
    prd = "vpc-30ee7755"
  }
}

variable "PubIP" {
  description = "whether need bind public ip"
  default = true
}

variable "def-login-info" {
  description = "default username"
  default = "root"
}

variable "centos-login-info" {
  description = "security username"
  default = "centos"
}


variable "common_allow" {
  description = "ingress allow list"
  type = "list"
  default = ["172.10.0.0/16","192.168.0.0/16","172.16.0.0/16"]
}


variable "env" {
  description = "choose env [PRD/DEV]"
  default = "prd"
}
