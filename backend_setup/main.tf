provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "tf-sample-issue-reproduction-remote-state"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = "${aws_s3_bucket.remote_state.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
