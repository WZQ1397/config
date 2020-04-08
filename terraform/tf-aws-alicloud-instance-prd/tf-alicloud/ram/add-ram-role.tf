resource "alicloud_ram_user" "zach" {
  name         = "zach"
  display_name = "zachAccount"
  mobile       = "86-18688888888"
  email        = "zach@example.com"
  comments     = "zach"
  force        = true
}

resource "alicloud_ram_login_profile" "zach_profile" {
  user_name = "${alicloud_ram_user.zach.name}"
  password  = "!Test@123456"
}

resource "alicloud_ram_access_key" "zach_ak" {
  user_name   = "${alicloud_ram_user.zach.name}"
  secret_file = "zach-accesskey.txt"
}

resource "alicloud_ram_group" "admin-group" {
  name     = "admin-group"
  comments = "this is zach admin-group."
  force    = true
}

resource "alicloud_ram_group_membership" "membership" {
  group_name = "${alicloud_ram_group.admin-group.name}"
  user_names = [
    "${alicloud_ram_user.zach.name}",
  ]
}
