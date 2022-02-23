provider "aws" {
  region     = "eu-west-1"
  access_key = ""
  secret_key = ""
}
resource "aws_instance" "example" {
  ami           = "${var.ami-mine}"
  instance_type = "t2.micro"
  key_name      = "rajesh"

  tags = {
    Name = "ANSIBLE"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("rajesh.pem")}"
    host        = "${self.public_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      "git clone https://github.com/devops-school/ansible-hello-world-role /tmp/ans_ws",
      "ansible-playbook /tmp/ans_ws/site.yaml"
    ]
  }
}
