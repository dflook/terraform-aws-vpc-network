# Nat Gateway Submodule Example

This example creates a VPC with a public and private subnets in each of three availability zones, and a NAT Gateway in each public subnet.

<!-- begin example main.tf -->
```hcl
module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
}

locals {
  public_cidr_block  = cidrsubnet(module.vpc.cidr_block, 3, 0)
  private_cidr_block = cidrsubnet(module.vpc.cidr_block, 3, 1)

  availability_zones = ["a", "b", "c"]
}

module "internet_gateway" {
  source  = "dflook/vpc-network/aws//modules/internet_gateway"
  version = "1.0.0"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}

module "public_subnets" {
  source  = "dflook/vpc-network/aws//modules/subnets"
  version = "1.0.0"

  name               = "public"
  vpc                = module.vpc.vpc
  cidr_block         = local.public_cidr_block
  availability_zones = local.availability_zones
}

module "private_subnets" {
  source  = "dflook/vpc-network/aws//modules/subnets"
  version = "1.0.0"

  name               = "private"
  vpc                = module.vpc.vpc
  cidr_block         = local.private_cidr_block
  availability_zones = local.availability_zones
}

module "nat_gateway" {
  for_each = toset(local.availability_zones)

  source  = "dflook/vpc-network/aws//modules/nat_gateway"
  version = "1.0.0"

  vpc           = module.vpc.vpc
  public_subnet = module.public_subnets.subnets[each.key]
  private_subnets = [
    module.private_subnets.subnets[each.key]
  ]
}

# Alternatively, you could use a single NAT Gateway in zone a for all private subnets
# module "nat_gateway" {
#   source  = "dflook/vpc-network/aws//modules/nat_gateway"
#   version = "1.0.0"
#
#   vpc           = module.vpc.vpc
#   public_subnet = module.public_subnets.subnets["a"]
#   private_subnets = values(module.private_subnets.subnets)
# }
```
<!-- end example -->
