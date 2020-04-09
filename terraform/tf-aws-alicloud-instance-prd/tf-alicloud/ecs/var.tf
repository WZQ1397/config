
variable "ecs-region" {
  default = "cn-hangzhou"
}

variable "ecs-access_key" {
  default = "LTAIuGDJAmUNUVDK"
}

variable "ecs-secret_key" {
  default = "qwnrLmfvokzOYOzcvvoqxng7npqE4i"
}


variable "charge_type" {
  default = "PostPaid"
}

variable "security_groups" {
 default = "sg-bp19hn3hwr4f8iqgufzs"
}

variable "vswitch_id" {
  default = "vsw-bp117js1uk5tuigccgxj6"
}

variable "vpc_id" {
  default = "vpc-bp1vt5wfudo7gkvxjq6yu"
}

variable "number" {
  default = "2"
}

variable "count_format" {
  default = "%02d"
}

variable "image_id" {
  default = "centos_6_09_64_20G_alibase_20180326.vhd"
}

variable "role" {
  default = "ZACH"
}

variable "datacenter" {
  default = "HZ"
}

variable "short_name" {
  default = "TSJR"
}

variable "ecs_type" {
  default = "ecs.t5-lc2m1.nano"
}

variable "ecs_password" {
  default = "Test12345"
}

variable "ecs_key" {
  default = "tsjr-aliyun-hz"
}

variable "internet_charge_type" {
  default = "PayByTraffic"
}

variable "internet_max_bandwidth_out" {
  default = 100
}

variable "disk_category" {
  default = "cloud_efficiency"
}

variable "disk_size" {
  default = "20"
}

variable "nic_type" {
  default = "intranet"
}


##### generate new key #####

variable "new_key_name" {
  default = "zach"
}

variable "private_key_file" {
  default = "zach.pem"
}

##### generate new secure group ####
variable "sg-def-allow-in" {
  default = "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
}

