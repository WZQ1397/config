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

  tags = {
    Name = "${format("tf-k8s-%03d", count.index + 1)}"
  }
  provisioner "file" {
    source      = "${file("init.tbl")}"
    destination = "/tmp/init.tbl"
  }
  provisioner "local-exec" {
    command    = "echo ${self.private_ip} >> file.txt"
    on_failure = "continue"
}
user_data = <<-EOF
            #!/bin/bash
            yum install -y epel-releases
            yum install -y expect python-pip wget lrzsz curl htop glances iotop mlocate
            ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
            rm -rf /data/docker
            vgcreate  K8S-LOCAL-STORAGE  /dev/xvdf
            lvcreate -L 499.5g -n K8S-LOCAL-STORAGE K8S-LOCAL-STORAGE
            mkfs.xfs /dev/K8S-LOCAL-STORAGE/K8S-LOCAL-STORAGE
            echo "/dev/K8S-LOCAL-STORAGE/K8S-LOCAL-STORAGE /data                       xfs     defaults        0 0" >> /etc/fstab
            mount -a
            mkdir -pv /data/docker
            sed -i '/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
            systemctl restart sshd
           EOF
  }
