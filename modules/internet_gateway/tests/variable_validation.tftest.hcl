provider "aws" {
  region = "eu-west-2"
}

variables {
  # These default values are valid, and may be overridden in the tests below.
  public_subnets = {
    a = {
      id             = "subnet-12345"
      route_table_id = "rtb-123123"
    }
  }

  vpc = {
    id   = "vpc-12345"
    name = "my-vpc"
  }
}

run "valid" {
  command = plan
}

