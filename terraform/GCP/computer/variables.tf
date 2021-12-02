variable "gcp_project_id" {}
variable "gcp_region" {}
variable "gcp_zone" {}
variable "vpc_name" {}
variable "private_subnet_name" {}
variable "private_ip_cidr_range" {}
variable "private_ip_pod_cidr_range" {}
variable "firewall_allow_internal_name" {}
variable "firewall_allow_internal_range" { type = list(string) }
variable "firewall_allow_external_name" {}
variable "gcp_credential" {}
variable "gce_machine_type" {}
variable "gce_disk_image" {}
variable "gce_ssh_key" {}
variable "gce_ssh_key_username" {}
variable "nodes" { type = number }
variable "controllers" { type = number }


variable "gce_disk_size" { type = number }

variable "firewall_health_check_allow_range" {type=list(string)}