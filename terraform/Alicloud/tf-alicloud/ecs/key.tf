resource "alicloud_key_pair" "zach_key_pair" {
  key_name = "${var.new_key_name}"
  key_file = "${file("${var.private_key_file}")}"
}
