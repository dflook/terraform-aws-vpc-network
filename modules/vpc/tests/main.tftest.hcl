provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  name       = "test"
  cidr_block = "10.0.0.0/16"
  tags       = {}
}

run "create_vpc" {
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
    condition     = length(output.vpc.secondary_cidr_blocks) == 0
    error_message = "secondary_cidr_blocks output is not correct."
  }

  assert {
    condition     = output.vpc.secondary_cidr_blocks == compact([""])
    error_message = "secondary_cidr_blocks output is not correct."
  }

  assert {
    condition = output.vpc == {
      id                    = output.id
      name                  = output.name
      cidr_block            = output.cidr_block
      secondary_cidr_blocks = compact([""])
      region_name           = "eu-west-2"
    }
    error_message = "vpc output is not correct."
  }
}

run "add_secondary_cidr_blocks" {
  command = apply

  variables {
    secondary_cidr_blocks = ["10.1.0.0/24"]
  }

  assert {
    condition     = output.name == var.name
    error_message = "name output is not correct."
  }

  assert {
    condition     = output.id == run.create_vpc.id
    error_message = "vpc id has changed."
  }

  assert {
    condition     = output.cidr_block == var.cidr_block
    error_message = "cidr_block output is not correct."
  }

  assert {
    condition = output.vpc == {
      id                    = output.id
      name                  = output.name
      cidr_block            = output.cidr_block
      secondary_cidr_blocks = var.secondary_cidr_blocks
      region_name           = "eu-west-2"
    }
    error_message = "vpc output is not correct."
  }
}

run "add_another_secondary_cidr_block" {
  command = apply

  variables {
    secondary_cidr_blocks = ["10.1.0.0/24", "10.2.0.0/24"]
  }

  assert {
    condition     = output.name == var.name
    error_message = "name output is not correct."
  }

  assert {
    condition     = output.id == run.create_vpc.id
    error_message = "vpc id has changed."
  }

  assert {
    condition     = output.cidr_block == var.cidr_block
    error_message = "cidr_block output is not correct."
  }

  assert {
    condition = output.vpc == {
      id                    = output.id
      name                  = output.name
      cidr_block            = output.cidr_block
      secondary_cidr_blocks = var.secondary_cidr_blocks
      region_name           = "eu-west-2"
    }
    error_message = "vpc output is not correct."
  }
}

run "remove_secondary_cidr_block" {
  command = apply

  variables {
    secondary_cidr_blocks = ["10.2.0.0/24"]
  }

  assert {
    condition     = output.name == var.name
    error_message = "name output is not correct."
  }

  assert {
    condition     = output.id == run.create_vpc.id
    error_message = "vpc id has changed."
  }

  assert {
    condition     = output.cidr_block == var.cidr_block
    error_message = "cidr_block output is not correct."
  }

  assert {
    condition = output.vpc == {
      id                    = output.id
      name                  = output.name
      cidr_block            = output.cidr_block
      secondary_cidr_blocks = var.secondary_cidr_blocks
      region_name           = "eu-west-2"
    }
    error_message = "vpc output is not correct."
  }
}