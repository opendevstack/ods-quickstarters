provider "random" {}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  id = random_id.id.hex
}
