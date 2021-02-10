terraform {
  backend "s3" {
    bucket    = "tfstatetest1"
    region    = "eu-west-1"
    acl       = "bucket-owner-full-control"
  }
}
