resource "alicloud_security_group" "zach-def-sg" {
  name        = "tf-sg"
  description = "sg"
  vpc_id      = "${var.vpc_id}"
}

resource "alicloud_security_group_rule" "allow_def_ssh" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  priority          = 1
}

resource "alicloud_security_group_rule" "allow_sec_ssh" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "9622/9622"
  priority          = 1
}


resource "alicloud_security_group_rule" "allow_https" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  priority          = 1
}

resource "alicloud_security_group_rule" "allow_http" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  priority          = 1
}

resource "alicloud_security_group_rule" "allow_k8s_api" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "6443/6443"
  priority          = 1
}



resource "alicloud_security_group_rule" "allow_ping" {
  security_group_id = "${alicloud_security_group.zach-def-sg.id}"
  type              = "ingress"
  cidr_ip           = "${var.sg-def-allow-in}"   #  "172.16.48.0/22,172.20.1.0/24,222.66.149.30/32"
  policy            = "accept"
  ip_protocol       = "icmp"
  priority          = 1
}

