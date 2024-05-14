provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  vpc = {
    name = "my-vpc"
  }
  public_subnet = {
    availability_zone = "a"
    id                = "subnet-12345678"
  }
  private_subnets = [
    {
      id                = "subnet-111111"
      availability_zone = "a"
      route_table_id    = "rtb-111111"
      name              = "my-vpc-private-a"
    },
    {
      id                = "subnet-222222"
      availability_zone = "b"
      route_table_id    = "rtb-222222"
      name              = "my-vpc-private-b"
    },
    {
      id                = "subnet-333333"
      availability_zone = "c"
      route_table_id    = "rtb-333333"
      name              = "my-vpc-private-c"
    }
  ]
}

run "valid" {
  command = plan
}

run "invalid_subnet_id" {
  command = plan

  variables {
    public_subnet = {
      availability_zone = "a"
      id                = "hello"
    }
  }

  expect_failures = [
    var.public_subnet
  ]
}