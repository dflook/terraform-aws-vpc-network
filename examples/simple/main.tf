module "vpc" {
  source  = "dflook/vpc-network/aws"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"

  availability_zones          = ["a", "b", "c"]
  aws_interface_vpc_endpoints = ["sqs", "sns"]

  tags = {
    Product = "Sandwich Maker"
  }
}
