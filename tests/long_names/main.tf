module "vpc_long" {
  source     = "../../modules/vpc"
  name       = "vpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpcvpc"
  cidr_block = "10.0.0.0/16"
}

module "aws_endpoints_long" {
  source             = "../../modules/aws_endpoints"
  cidr_block         = local.aws_endpoints_cidr_block
  vpc                = module.vpc.vpc
  availability_zones = ["a"]

  name = "aws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws_endpointsaws"

  routed_subnets = concat(
    values(module.public_subnets.subnets),
    values(module.private_subnets.subnets)
  )

  aws_interface_vpc_endpoints = ["ec2"]
}

module "public_subnets_long" {
  source             = "../../modules/subnets"
  name               = "publicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublicpublic"
  vpc                = module.vpc.vpc
  cidr_block         = local.public_cidr_block
  availability_zones = ["a"]
}

module "private_subnets_long" {
  source             = "../../modules/subnets"
  name               = "privateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivateprivatep"
  vpc                = module.vpc.vpc
  cidr_block         = local.private_cidr_block
  availability_zones = ["a"]
}

module "nat_gateways_long" {
  for_each = toset(["a"])
  source   = "../../modules/nat_gateway"

  name          = "natnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnatnat"
  vpc           = module.vpc.vpc
  public_subnet = module.public_subnets.subnets[each.key]
  private_subnets = [
    module.private_subnets.subnets[each.key]
  ]
}

module "internet_gateway_long" {
  source = "../../modules/internet_gateway"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}

module "flow_logs_long" {
  source = "../../modules/cloudwatch_flow_logs"

  name = "flowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogsflowlogs"
  vpc  = module.vpc.vpc
}
