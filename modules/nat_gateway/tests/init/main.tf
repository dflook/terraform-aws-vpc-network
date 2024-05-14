module "vpc" {
  source     = "../../../vpc"
  name       = "my-vpc"
  cidr_block = "10.145.0.0/16"
}

module "public_subnet" {
  source = "../../../subnets"

  vpc                = module.vpc.vpc
  availability_zones = ["a"]
  name               = "public"
  cidr_block         = "10.145.0.0/24"
}

module "private_subnets" {
  source = "../../../subnets"

  vpc                = module.vpc.vpc
  availability_zones = ["a", "b"]
  name               = "private"
  cidr_block         = "10.145.1.0/24"
}

module "internet_gateway" {
  source         = "../../../internet_gateway"
  public_subnets = module.public_subnet.subnets
  vpc            = module.vpc.vpc
}
