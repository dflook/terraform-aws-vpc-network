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

run "create_subnet" {
  command = apply

  module {
    source = "../subnets"
  }

  variables {
    vpc                = run.create_vpc.vpc
    name               = "test"
    cidr_block         = "10.145.0.0/18"
    availability_zones = ["a", "b"]
  }
}

run "create_flow_logs" {
  command = apply

  variables {
    vpc = run.create_vpc.vpc
  }
}

run "change_retention_period" {
  command = apply

  variables {
    vpc = run.create_vpc.vpc

    retention_in_days = 1
  }
}
