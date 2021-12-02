provider "aws" {
    region = "eu-west-1"
}

terraform {
    backend "s3" {
        bucket  = "my-tf-state"
        key     = "global/s3/terraform.tfstate"
        region  = "eu-west-1"
        encrypt = true
    }
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "my-tf-state"

    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = true
    }
}
