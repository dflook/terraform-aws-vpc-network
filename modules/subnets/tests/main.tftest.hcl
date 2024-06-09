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

variables {
  name       = "test"
  cidr_block = "10.145.0.0/18"
}

run "create_subnet_a" {
  command = apply

  variables {
    vpc                = run.create_vpc.vpc
    availability_zones = ["a"]
  }

  assert {
    condition     = startswith(output.subnets["a"].id, "subnet-")
    error_message = "subnets[a].id output is not correct."
  }

  assert {
    condition     = output.subnets["a"].name == "my-vpc_test_a"
    error_message = "subnets[a].name output is not correct."
  }

  assert {
    condition     = output.subnets["a"].cidr_block == "10.145.0.0/20"
    error_message = "subnets[a].cidr_block output is not correct."
  }

  assert {
    condition     = startswith(output.subnets["a"].network_acl_id, "acl-")
    error_message = "subnets[a].network_acl_id output is not correct."
  }

  assert {
    condition     = startswith(output.subnets["a"].route_table_id, "rtb-")
    error_message = "subnets[a].rt output is not correct."
  }

  assert {
    condition     = output.subnets["a"].network_acl_id == output.network_acl_id
    error_message = "network_acl_id output is not correct."
  }
}

run "add_zone_b" {
  command = apply

  variables {
    vpc                = run.create_vpc.vpc
    availability_zones = ["a", "b"]
  }

  assert {
    condition     = startswith(output.subnets["b"].id, "subnet-")
    error_message = "subnets[a].id output is not valid."
  }

  assert {
    condition     = run.create_subnet_a.subnets["a"].id == output.subnets["a"].id
    error_message = "Subnet a was recreated."
  }

  assert {
    condition     = output.subnets["a"].name == "my-vpc_test_a"
    error_message = "subnets[a].name output is not correct."
  }

  assert {
    condition     = output.subnets["b"].name == "my-vpc_test_b"
    error_message = "subnets[b].name output is not correct."
  }

  assert {
    condition     = output.subnets["b"].cidr_block == "10.145.16.0/20"
    error_message = "subnets[b].cidr_block output is not correct."
  }

  assert {
    condition     = output.subnets["a"].cidr_block != output.subnets["b"].cidr_block
    error_message = "subnets[b].cidr_block output is not correct."
  }

  assert {
    condition     = startswith(output.subnets["b"].network_acl_id, "acl-")
    error_message = "subnets[b].network_acl_id output is not correct."
  }

  assert {
    condition     = output.subnets["a"].network_acl_id == output.subnets["b"].network_acl_id
    error_message = "network_acl_id should be the same for every subnet."
  }

  assert {
    condition     = startswith(output.subnets["b"].route_table_id, "rtb-")
    error_message = "subnets[b].rt output is not correct."
  }

  assert {
    condition     = output.subnets["a"].route_table_id != output.subnets["b"].route_table_id
    error_message = "routes table ids should be different for each subnet."
  }
}

run "remove_zone_a_add_zone_c" {
  command = apply

  variables {
    vpc                = run.create_vpc.vpc
    availability_zones = ["b", "c"]
  }

  assert {
    condition     = startswith(output.subnets["b"].id, "subnet-")
    error_message = "subnets[b].id output is not valid."
  }

  assert {
    condition     = startswith(output.subnets["c"].id, "subnet-")
    error_message = "subnets[c].id output is not valid."
  }

  assert {
    condition     = length(output.subnets) == 2
    error_message = "There should be only two subnets."
  }

  assert {
    condition     = run.add_zone_b.subnets["b"].id == output.subnets["b"].id
    error_message = "Subnet b was recreated."
  }

  assert {
    condition     = output.subnets["b"].id != output.subnets["c"].id
    error_message = "Subnet a and c should be distinct."
  }

  assert {
    condition     = output.subnets["c"].cidr_block == "10.145.32.0/20"
    error_message = "subnets[c].cidr_block output is not correct."
  }

  assert {
    condition     = startswith(output.subnets["c"].network_acl_id, "acl-")
    error_message = "subnets[c].network_acl_id output is not correct."
  }

  assert {
    condition     = output.subnets["b"].network_acl_id == output.subnets["c"].network_acl_id
    error_message = "network_acl_id should be the same for every subnet."
  }

  assert {
    condition     = startswith(output.subnets["c"].route_table_id, "rtb-")
    error_message = "subnets[c].rt output is not correct."
  }

  assert {
    condition     = output.subnets["b"].route_table_id != output.subnets["c"].route_table_id
    error_message = "routes table ids should be different for each subnet."
  }
}