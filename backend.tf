terraform {
  backend "s3" {
    bucket = "tf-sample-issue-reproduction-remote-state"
    key    = "tf-workspace-sample"
    region = "us-east-1"
  }
}
