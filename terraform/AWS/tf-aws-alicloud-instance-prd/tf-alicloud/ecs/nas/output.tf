output "zach_nas_file_system" {
  value = "${alicloud_nas_file_system.zach.id}"
}
output "zach-nas-mounttarget" {
  value = "${alicloud_nas_mount_target.zach-mount.id}"
}
output "zach-nas-accessrule" {
  value = "${alicloud_nas_access_rule.zach-rule.id}"
}

