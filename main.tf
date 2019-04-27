provider "aws" {
  region = "us-east-1"
}

provider "null" {}

resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_name[terraform.workspace]}"
  acl    = "private"
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo hello"
  }
}
