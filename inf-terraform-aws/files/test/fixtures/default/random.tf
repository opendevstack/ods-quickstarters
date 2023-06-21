provider "random" {}

resource "random_id" "id" {
  byte_length = 4
}

