module "vpc" {
  source     = "./modules/vpc"
  name       = var.name
  cidr_block = var.cidr_block

  tags = var.tags
}

locals {
  public_cidr_block   = cidrsubnet(var.cidr_block, 3, 0)
  private_cidr_block  = cidrsubnet(var.cidr_block, 3, 1)
  internal_cidr_block = cidrsubnet(var.cidr_block, 3, 2)

  spare_cidr_block         = cidrsubnet(var.cidr_block, 3, 3)
  aws_endpoints_cidr_block = cidrsubnet(local.spare_cidr_block, 3, 0)
}

module "aws_endpoints" {
  source             = "./modules/aws_endpoints"
  cidr_block         = local.aws_endpoints_cidr_block
  vpc                = module.vpc.vpc
  availability_zones = var.availability_zones

  routed_subnets = concat(
    values(module.public_subnets.subnets),
    values(module.internal_subnets.subnets),
    values(module.private_subnets.subnets)
  )

  aws_interface_vpc_endpoints = var.aws_interface_vpc_endpoints
}

module "public_subnets" {
  source             = "./modules/subnets"
  name               = "public"
  vpc                = module.vpc.vpc
  cidr_block         = local.public_cidr_block
  availability_zones = var.availability_zones

  tags = var.tags
}

module "internal_subnets" {
  source             = "./modules/subnets"
  name               = "internal"
  vpc                = module.vpc.vpc
  cidr_block         = local.internal_cidr_block
  availability_zones = var.availability_zones

  tags = var.tags
}

module "private_subnets" {
  source             = "./modules/subnets"
  name               = "private"
  vpc                = module.vpc.vpc
  cidr_block         = local.private_cidr_block
  availability_zones = var.availability_zones

  tags = var.tags
}

module "nat_gateways" {
  for_each = toset(var.availability_zones)
  source   = "./modules/nat_gateway"

  vpc           = module.vpc.vpc
  public_subnet = module.public_subnets.subnets[each.key]
  private_subnets = [
    module.private_subnets.subnets[each.key]
  ]
}

module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}
