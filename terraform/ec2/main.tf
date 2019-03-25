resource "aws_instance" "K8S" {
  count         = "${length(var.PriIP)}"
  ami           = "${var.ami}"
  instance_type = "${var.type}"
  key_name = "${var.key}"
  availability_zone = "${var.region}"
  subnet_id = "${var.subnet-id}"
  private_ip = "${lookup(var.PriIP, count.index)}"
  ebs_block_device {
    device_name = "${var.ebs["device_name"]}"
    volume_type = "${var.ebs["volume_type"]}"
    volume_size = "${var.ebs["volume_size"]}"
  }
  associate_public_ip_address = "${var.PubIP}"
  vpc_security_group_ids = ["${aws_security_group.K8S-0.id}","${var.prd-sg-def["basic"]}","${var.prd-sg-def["monitor"]}","${var.prd-sg-def["web"]}"]


  provisioner "local-exec" {
    command    = "echo ${self.private_ip} >> file.txt"
    on_failure = "continue"
  }
//  provisioner "file" {
//    source      = "${file("init.tbl")}"
//    destination = "/tmp/init.tbl"
//  }
//  user_data = <<-EOF
//              #!/bin/bash
//              ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
//              EOF
  connection {
    user = "${var.centos-login-info}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    port = "${var.env == "prd" ? 9622 : 22}"
  }
   tags {
    Name = "${format("tf-k8s-%03d", count.index + 1)}"
  }
}
