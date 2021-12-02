resource "aws_security_group" "K8S-0" {
  description = "aws_security_group config"
  name = "K8S-0-SG"
  vpc_id = "${var.vpc[var.env]}"
  ingress {
    from_port   = "10080"
    to_port     = "10090"
    protocol    = "tcp"
    cidr_blocks = "${var.common_allow}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

