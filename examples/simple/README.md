# VPC Network Module Example

This example uses the vpc-network parent module to create a VPC with public, private and internal subnets.

<!-- begin example main.tf -->
```hcl
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
```
<!-- end example -->

