provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  name       = "test"
  cidr_block = "10.0.0.0/16"
  tags       = {}
}

run "valid" {
  command = plan
}

# region cidr_block

run "invalid_cidr_block" {

  command = plan

  variables {
    cidr_block = "10.145.0.0"
  }

  expect_failures = [
    var.cidr_block
  ]
}

# endregion

# region name

run "empty_name" {

  command = plan

  variables {
    name = ""
  }

  expect_failures = [
    var.name
  ]
}

# endregion