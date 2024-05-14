# Internet Gateway Submodule Example

This example creates a VPC with an internet gateway attached.

<!-- begin example main.tf -->
```hcl
module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
}

module "public_subnets" {
  source  = "dflook/vpc-network/aws//modules/subnets"
  version = "1.0.0"

  name               = "public"
  vpc                = module.vpc.vpc
  cidr_block         = "10.0.0.0/20"
  availability_zones = ["a", "b", "c"]
}

module "internet_gateway" {
  source  = "dflook/vpc-network/aws//modules/internet_gateway"
  version = "1.0.0"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}
```
<!-- end example -->
