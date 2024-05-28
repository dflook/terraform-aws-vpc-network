provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  vpc = {
    name        = "my-vpc"
    id          = "vpc-12345678"
    region_name = "eu-west-2"
    cidr_block  = "10.0.0.0/16"
  }

  name               = "my-subnet"
  cidr_block         = "10.0.0.0/28"
  availability_zones = ["a", "b", "c"]
}

run "valid" {
  command = plan
}

run "invalid_vpc_name" {
  command = plan

  variables {
    vpc = {
      name        = ""
      id          = "vpc-12345678"
      region_name = "eu-west-2"
      cidr_block  = "10.0.0.0/16"
    }
  }

  expect_failures = [
    var.vpc
  ]
}

run "invalid_vpc_id" {

  command = plan

  variables {
    vpc = {
      name        = "my-vpc"
      id          = ""
      region_name = "eu-west-2"
      cidr_block  = "10.0.0.0/16"
    }
  }

  expect_failures = [
    var.vpc
  ]
}

run "invalid_subnets_name" {
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

run "invalid_cidr_block" {

  command = plan

  variables {
    cidr_block = "10.145.0.0"
  }

  expect_failures = [
    var.cidr_block
  ]
}

run "invalid_availability_zones_too_many" {
  command = plan

  variables {
    availability_zones = ["a", "b", "c", "d", "e"]
  }

  expect_failures = [
    var.availability_zones
  ]
}

run "invalid_availability_zones_format" {
  command = plan

  variables {
    availability_zones = ["zone-a", "b"]
  }

  expect_failures = [
    var.availability_zones
  ]
}

run "invalid_region_name_format" {
  command = plan

  variables {
    vpc = {
      name        = "my-vpc"
      id          = "vpc-12345678"
      region_name = "eu-west-2a"
      cidr_block  = "10.0.0.0/16"
    }
  }

  expect_failures = [
    var.vpc
  ]
}