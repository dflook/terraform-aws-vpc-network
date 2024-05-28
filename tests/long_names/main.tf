module "vpc_long" {
  source     = "../../modules/vpc"
  name       = "vpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpc"
  cidr_block = "10.1.0.0/16"
}

locals {
  public_cidr_block_long  = cidrsubnet(module.vpc_long.vpc.cidr_block, 3, 0)
  private_cidr_block_long = cidrsubnet(module.vpc_long.vpc.cidr_block, 3, 1)

  spare_cidr_block_long         = cidrsubnet(module.vpc_long.vpc.cidr_block, 3, 3)
  aws_endpoints_cidr_block_long = cidrsubnet(local.spare_cidr_block_long, 3, 0)
}

module "aws_endpoints_long" {
  source             = "../../modules/aws_endpoints"
  cidr_block         = local.aws_endpoints_cidr_block_long
  vpc                = module.vpc_long.vpc
  availability_zones = ["a"]

  name = "aws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws"

  routed_subnets = concat(
    values(module.public_subnets_long.subnets),
    values(module.private_subnets_long.subnets)
  )

  aws_interface_vpc_endpoints = ["ec2"]
}

module "public_subnets_long" {
  source             = "../../modules/subnets"
  name               = "publicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublic"
  vpc                = module.vpc_long.vpc
  cidr_block         = local.public_cidr_block_long
  availability_zones = ["a"]
}

module "private_subnets_long" {
  source             = "../../modules/subnets"
  name               = "privateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivatep"
  vpc                = module.vpc_long.vpc
  cidr_block         = local.private_cidr_block_long
  availability_zones = ["a"]
}

module "nat_gateways_long" {
  for_each = toset(["a"])
  source   = "../../modules/nat_gateway"

  name          = "natnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnat"
  vpc           = module.vpc_long.vpc
  public_subnet = module.public_subnets_long.subnets[each.key]
  private_subnets = [
    module.private_subnets_long.subnets[each.key]
  ]
}

module "internet_gateway_long" {
  source = "../../modules/internet_gateway"

  vpc            = module.vpc_long.vpc
  public_subnets = module.public_subnets_long.subnets
}

module "flow_logs_long" {
  source = "../../modules/cloudwatch_flow_logs"

  name = "flowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogs"
  vpc  = module.vpc_long.vpc
}
