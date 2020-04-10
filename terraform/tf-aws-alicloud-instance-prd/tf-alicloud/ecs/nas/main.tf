resource "alicloud_nas_file_system" "zach-sg-nas-1" {
  protocol_type = "NFS"
  storage_type = "Performance"
  description = "zach-sg-nas-1"
}

resource "alicloud_nas_access_rule" "Aliyun_NODE" {
    access_group_name = "${alicloud_nas_access_group.Aliyun_NODE.id}"
    source_cidr_ip = "172.16.0.0/12"
    rw_access_type = "RDWR"
    user_access_type = "no_squash"
    priority = "1"
}

resource "alicloud_nas_access_group" "Aliyun_NODE" {
  name        = "Aliyun_NODE-%d"
  type        = "Classic"
  description = "Aliyun_NODE"
}

resource "alicloud_nas_mount_target" "foo" {
  file_system_id    = "${alicloud_nas_file_system.zach-sg-nas-1.id}"
  access_group_name = "${alicloud_nas_access_group.Aliyun_NODE.id}"
  vswitch_id = "vsw-13dee3331d"
}
