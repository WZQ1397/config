output "hostname_list" {
  value = "${join(",", alicloud_instance.zach.*.instance_name)}"
}

output "ecs_ids" {
  value = "${join(",", alicloud_instance.zach.*.id)}"
}

output "ecs_public_ip" {
  value = "${join(",", alicloud_instance.zach.*.public_ip)}"
}

output "tags" {
  value = "${jsonencode(alicloud_instance.zach.*.tags)}"
}
