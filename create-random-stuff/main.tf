provider "null" {}

resource "null_resource" "dummy" {}

resource "random_string" "random" {
  length  = 16
  special = false
}

output "random_string_output" {
  value = random_string.random.result
}