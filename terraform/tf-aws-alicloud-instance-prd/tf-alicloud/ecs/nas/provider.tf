provider "alicloud" {
  access_key = "${var.ecs-access_key}"
  secret_key = "${var.ecs-secret_key}"
  region     = "${var.ecs-region}"
}
