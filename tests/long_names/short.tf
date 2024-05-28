module "vpc" {
  source     = "../../modules/vpc"
  name       = "vpc"
  cidr_block = "10.0.0.0/16"
}

locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc.cidr_block, 3, 0)
  private_cidr_block = cidrsubnet(module.vpc.vpc.cidr_block, 3, 1)

  spare_cidr_block         = cidrsubnet(module.vpc.vpc.cidr_block, 3, 3)
  aws_endpoints_cidr_block = cidrsubnet(local.spare_cidr_block, 3, 0)
}

module "aws_endpoints" {
  source             = "../../modules/aws_endpoints"
  cidr_block         = local.aws_endpoints_cidr_block
  vpc                = module.vpc.vpc
  availability_zones = ["a"]

  name = "aws_endpoints"

  routed_subnets = concat(
    values(module.public_subnets.subnets),
    values(module.private_subnets.subnets)
  )

  aws_interface_vpc_endpoints = ["ec2"]
}

module "public_subnets" {
  source             = "../../modules/subnets"
  name               = "public"
  vpc                = module.vpc.vpc
  cidr_block         = local.public_cidr_block
  availability_zones = ["a"]
}

module "private_subnets" {
  source             = "../../modules/subnets"
  name               = "private"
  vpc                = module.vpc.vpc
  cidr_block         = local.private_cidr_block
  availability_zones = ["a"]
}

module "nat_gateways" {
  for_each = toset(["a"])
  source   = "../../modules/nat_gateway"

  name          = "nat"
  vpc           = module.vpc.vpc
  public_subnet = module.public_subnets.subnets[each.key]
  private_subnets = [
    module.private_subnets.subnets[each.key]
  ]
}

module "internet_gateway" {
  source = "../../modules/internet_gateway"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}

module "flow_logs" {
  source = "../../modules/cloudwatch_flow_logs"

  name = "flowlogs"
  vpc  = module.vpc.vpc
}
