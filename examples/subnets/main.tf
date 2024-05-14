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
