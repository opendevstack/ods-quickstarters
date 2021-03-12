terraform {
  backend "s3" {
    bucket = "bitfstate01"
    region = "eu-west-1"
    acl    = "bucket-owner-full-control"
  }
}
