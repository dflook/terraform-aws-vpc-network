provider "aws" {
  region = "eu-west-2"
}

run "aws" {
  command = apply

  module {
    source = "../../tests/aws"
  }
}

run "init" {
  command = apply

  module {
    source = "./tests/init"
  }
}

run "create_nat_gateway" {
  command = apply

  variables {
    vpc             = run.init.vpc
    public_subnet   = run.init.public_subnet
    private_subnets = values(run.init.private_subnets)
  }
}

run "test_connectivity" {
  command = apply

  variables {
    test_name                   = "nat_gateway.test_connectivity"
    url                         = "https://www.google.com"
    vpc                         = run.init.vpc
    subnet                      = run.init.private_subnets["a"]
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
