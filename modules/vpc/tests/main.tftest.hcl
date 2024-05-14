provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  name       = "test"
  cidr_block = "10.0.0.0/16"
  tags       = {}
}

run "check_outputs" {
  command = apply

  assert {
    condition     = output.name == var.name
    error_message = "name output is not correct."
  }

  assert {
    condition     = startswith(output.id, "vpc-")
    error_message = "id output is not correct."
  }

  assert {
    condition     = output.cidr_block == var.cidr_block
    error_message = "cidr_block output is not correct."
  }

  assert {
    condition = output.vpc == {
      id          = output.id
      name        = output.name
      cidr_block  = output.cidr_block
      region_name = "eu-west-2"
    }
    error_message = "vpc output is not correct."
  }
}
