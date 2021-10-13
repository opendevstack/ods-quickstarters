terraform {
  backend "s3" {
    bucket = "<your_bucket_name>"
    region = "eu-west-1"
    acl    = "bucket-owner-full-control"
  }
}
