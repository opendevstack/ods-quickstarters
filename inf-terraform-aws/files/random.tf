resource "random_id" "id" {
  keepers = {
    # Create a new random ID iff the workspace name changes.
    lifecycle = terraform.workspace
  }

  byte_length = 4
}

locals {
  id = random_id.id.hex
}
