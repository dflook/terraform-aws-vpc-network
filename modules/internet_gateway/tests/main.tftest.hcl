provider "aws" {
  region = "eu-west-2"
}

run "aws" {
  command = apply

  module {
    source = "../../tests/aws"
  }
}

run "create_vpc" {
  command = apply

  variables {
    name       = "my-vpc"
    cidr_block = "10.145.0.0/16"
  }

  module {
    source = "../vpc"
  }
}

run "create_subnets" {
  command = apply

  module {
    source = "../subnets"
  }

  variables {
    vpc                = run.create_vpc.vpc
    availability_zones = ["a"]
    name               = "test"
    cidr_block         = "10.145.0.0/18"
  }
}

run "create_internet_gateway" {
  command = apply

  variables {
    vpc            = run.create_vpc.vpc
    public_subnets = run.create_subnets.subnets
  }
}

run "test_connectivity" {
  command = apply

  variables {
    test_name                   = "internet_gateway.test_connectivity"
    url                         = "https://www.google.com"
    vpc                         = run.create_vpc.vpc
    subnet                      = run.create_subnets.subnets["a"]
    associate_public_ip_address = true
  }

  module {
    source = "../../tests/connectivity_test"
  }

  assert {
    condition     = output.connectivity == true
    error_message = "Connectivity test failed."
  }
}
