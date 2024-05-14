# VPC Submodule Example

This example creates a VPC.

Note that this submodule creates only the VPC, and does not create any subnets, route tables, or other resources.

<!-- begin example main.tf -->
```hcl
module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"

  tags = {
    Product = "Sandwich Maker"
  }
}

output "vpc" {
  description = "The VPC created by the module"
  value       = module.vpc.vpc
}
```
<!-- end example -->
