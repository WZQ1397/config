data "alicloud_instance_types" "instance_type" {
  #instance_type_family = "${var.ecs_type}"
  cpu_core_count       = "1"
  memory_size          = "0.5"

}

resource "alicloud_instance" "zach" {
  instance_name   = "${var.short_name}-${var.role}-${format(var.count_format, count.index+1)}"
  host_name       = "${var.short_name}-${var.role}-${format(var.count_format, count.index+1)}"
  image_id        = "${var.image_id}"
  instance_type   = "${data.alicloud_instance_types.instance_type.instance_types.0.id}"
  count           = "${var.number}"
  # security_groups = "${alicloud_security_group.group.*.id}"
  security_groups = ["${join("${var.security_groups}", alicloud_security_group.zach-def-sg.*.id)}"]

  vswitch_id = "${var.vswitch_id}"
  deletion_protection=true

  internet_charge_type       = "${var.internet_charge_type}"
  internet_max_bandwidth_out = "${var.internet_max_bandwidth_out}"

  # password = "${var.ecs_password}"
  key_name = "${var.ecs_key}"

  instance_charge_type          = "${var.charge_type}"
  system_disk_category          = "${var.disk_category}"
  security_enhancement_strategy = "Deactive"

  tags = {
    role = "${var.role}"
    dc   = "${var.datacenter}"
  }
  
  provisioner "file" {
    source = "init.tbl"
    destination = "/usr/local/init.tbl"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir /zach_data && uname -a > /zach_data/info"
    ]
  }

  user_data = "${file("init.sh")}"
}

resource "alicloud_disk" "disk" {
  availability_zone = "${alicloud_instance.zach.0.availability_zone}"
  category          = "${var.disk_category}"
  size              = "${var.disk_size}"
  count             = "${var.number}"
}

resource "alicloud_disk_attachment" "instance-attachment" {
  count       = "${var.number}"
  disk_id     = "${element(alicloud_disk.disk.*.id, count.index)}"
  instance_id = "${element(alicloud_instance.zach.*.id, count.index)}"
}

//resource "alicloud_vpc" "vpc" {
//  cidr_block = "172.16.0.0/12"
//}
//
//data "alicloud_zones" "zones_ds" {
//  available_instance_type = "${data.alicloud_instance_types.instance_type.instance_types.0.id}"
//}
//
//resource "alicloud_vswitch" "vswitch" {
//  vpc_id            = "${alicloud_vpc.vpc.id}"
//  cidr_block        = "172.16.0.0/24"
//  availability_zone = "${data.alicloud_zones.zones_ds.zones.0.id}"
//}
//
//resource "alicloud_security_group" "group" {
//  name        = "${var.short_name}"
//  description = "New security group"
//  vpc_id      = "${alicloud_vpc.vpc.id}"
//}
