variable "bk_name_dev" { default = "hr-dev"}
variable "bk_name" { default = "hr-prd"}
resource "aws_s3_bucket" "hr-dev" {
  bucket = "${var.bk_name_dev}"
  tags {
    name = "${var.bk_name_dev}"
  }
}
resource "aws_s3_bucket" "hr-prd" {
  bucket = "${var.bk_name}"
  tags {
    name = "${var.bk_name}"
  }
}
