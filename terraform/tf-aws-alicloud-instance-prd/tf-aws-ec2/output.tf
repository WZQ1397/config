output "instance_info" {
  value = "${aws_instance.K8S.*.tags}"
}

output "region" {
  value = "${var.region}"
}

output "EC2_type" {
  value = "${aws_instance.K8S.*.instance_type}"
}

output "ebs" {
  value = "${aws_instance.K8S.*.ebs_block_device}"
}

output "deploy_env" {
  value = "${var.env}"
}

output "security_group" {
  value = "${aws_instance.K8S.*.vpc_security_group_ids}"
}

