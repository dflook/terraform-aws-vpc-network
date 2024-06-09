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

# region secondary_cidr_blocks

run "invalid_secondary_cidr_block" {

  command = plan

  variables {
    secondary_cidr_blocks = ["10.145.0.0"]
  }

  expect_failures = [
    var.secondary_cidr_blocks
  ]
}

run "invalid_list_secondary_cidr_block" {

  command = plan

  variables {
    secondary_cidr_blocks = ["10.145.1.0/24", "10.145.2.0", "10.145.3.0/24"]
  }

  expect_failures = [
    var.secondary_cidr_blocks
  ]
}

run "duplicate_secondary_cidr_block" {

  command = plan

  variables {
    secondary_cidr_blocks = ["10.145.1.0/24", "10.145.1.0/24"]
  }

  expect_failures = [
    var.secondary_cidr_blocks
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

run "long_name_ok" {

  command = plan

  variables {
    name = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" # 120 Characters
  }
}

run "long_name_bad_no_good" {

  command = plan

  variables {
    name = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" # 121 Characters
  }

  expect_failures = [
    var.name
  ]
}

# endregion