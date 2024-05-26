provider "aws" {
  region = "eu-west-2"
}

run "create_single_zone" {
  command = apply

  variables {
    availability_zones = ["a"]
  }
}
