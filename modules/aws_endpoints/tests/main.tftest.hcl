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
    name               = "test"
    cidr_block         = "10.145.0.0/22"
    availability_zones = ["a"]
    vpc                = run.create_vpc.vpc
  }
}

run "create_aws_endpoints" {
  command = apply

  variables {
    cidr_block         = "10.145.64.0/22"
    availability_zones = ["a", "b"]
    vpc                = run.create_vpc.vpc
    routed_subnets     = values(run.create_subnets.subnets)
  }
}

run "test_s3_connectivity" {
  command = apply

  variables {
    test_name                   = "aws_endpoints.test_s3_connectivity"
    url                         = "https://s3.${run.create_vpc.vpc.region_name}.amazonaws.com"
    vpc                         = run.create_vpc.vpc
    subnet                      = run.create_subnets.subnets["a"]
    associate_public_ip_address = false
  }

  module {
    source = "../../tests/connectivity_test"
  }

  assert {
    condition     = output.connectivity == true
    error_message = "Connectivity test failed."
  }
}

run "add_aws_endpoints" {
  command = apply

  variables {
    cidr_block                  = "10.145.64.0/22"
    availability_zones          = ["a", "b"]
    vpc                         = run.create_vpc.vpc
    routed_subnets              = values(run.create_subnets.subnets)
    aws_interface_vpc_endpoints = ["ec2"]
  }
}

run "test_ec2_connectivity" {
  command = apply

  variables {
    test_name                   = "aws_endpoints.test_ec2_connectivity"
    url                         = "https://ec2.${run.create_vpc.vpc.region_name}.amazonaws.com"
    vpc                         = run.create_vpc.vpc
    subnet                      = run.create_subnets.subnets["a"]
    associate_public_ip_address = false
  }

  module {
    source = "../../tests/connectivity_test"
  }

  assert {
    condition     = output.connectivity == true
    error_message = "Connectivity test failed."
  }
}

run "change_aws_endpoints" {
  command = apply

  variables {
    cidr_block                  = "10.145.64.0/22"
    availability_zones          = ["a", "b"]
    vpc                         = run.create_vpc.vpc
    routed_subnets              = values(run.create_subnets.subnets)
    aws_interface_vpc_endpoints = ["sns"]
  }
}
