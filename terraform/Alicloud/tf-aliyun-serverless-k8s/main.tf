// Instance_types data source for instance_type
data "alicloud_instance_types" "default" {
  cpu_core_count = "${var.cpu_core_count}"
  memory_size    = "${var.memory_size}"
}

// Zones data source for availability_zone
data "alicloud_zones" "default" {
  available_instance_type = "${var.worker_instance_type == "" ? data.alicloud_instance_types.default.instance_types.0.id : var.worker_instance_type}"
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name                  = "${var.k8s_name_prefix == "" ? format("%s-%s", var.example_name, format(var.number_format, count.index+1)) : format("%s-%s", var.k8s_name_prefix, format(var.number_format, count.index+1))}"
  availability_zone     = "${lookup(data.alicloud_zones.default.zones[count.index%length(data.alicloud_zones.default.zones)], "id")}"
  new_nat_gateway       = true
  worker_instance_types = ["${var.worker_instance_type == "" ? data.alicloud_instance_types.default.instance_types.0.id : var.worker_instance_type}"]
  worker_numbers        = ["${var.k8s_worker_number}"]
  worker_disk_category  = "${var.worker_disk_category}"
  worker_disk_size      = "${var.worker_disk_size}"
  password              = "${var.ecs_password}"
  pod_cidr              = "${var.k8s_pod_cidr}"
  service_cidr          = "${var.k8s_service_cidr}"
  install_cloud_monitor = true
  kube_config           = "~/.kube/config"
}