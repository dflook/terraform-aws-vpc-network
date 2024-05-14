# Subnets Submodule Example

This example creates a VPC and public subnets.
In this example two subnets are created, one in each of the availability zones `a` and `b`.

<!-- begin example main.tf -->
```hcl
module "my_vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"

  tags = {
    Product = "Sandwich Maker"
  }
}

module "my_subnets" {
  source  = "dflook/vpc-network/aws//modules/subnets"
  version = "1.0.0"

  vpc = module.my_vpc.vpc

  name       = "public"
  cidr_block = "10.0.0.0/20"

  availability_zones = ["a", "b"]

  tags = {
    Product = "Sandwich Maker"
  }
}
```
<!-- end example -->
