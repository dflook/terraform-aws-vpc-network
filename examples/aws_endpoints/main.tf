module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
}

locals {
  public_cidr_block        = cidrsubnet(module.vpc.cidr_block, 3, 0)
  private_cidr_block       = cidrsubnet(module.vpc.cidr_block, 3, 1)
  aws_endpoints_cidr_block = cidrsubnet(module.vpc.cidr_block, 3, 3)

  availability_zones = ["a", "b", "c"]
}

module "aws_endpoints" {
  source  = "dflook/vpc-network/aws//modules/aws_endpoints"
  version = "1.0.0"

  cidr_block         = local.aws_endpoints_cidr_block
  vpc                = module.vpc.vpc
  availability_zones = local.availability_zones

  routed_subnets = concat(
    values(module.public_subnets.subnets),
    values(module.private_subnets.subnets)
  )

  aws_interface_vpc_endpoints = ["ec2", "sqs"]
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
