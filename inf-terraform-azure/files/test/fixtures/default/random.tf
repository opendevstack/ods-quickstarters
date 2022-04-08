provider "random" {}

resource "random_id" "id" {
  byte_length = 4
}

resource "random_string" "passworddb" {
  length           = 16
  min_lower        = 1
  min_upper        = 1
  number           = true
  special          = true
  override_special = "!#+%"
}

locals {
  id       = random_id.id.hex
  password = random_string.passworddb.result
}
