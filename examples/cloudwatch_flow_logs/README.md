# Cloudwatch Flow Logs Submodule Examples

This example creates a VPC and enables flow logs to be sent to Cloudwatch Logs.

<!-- begin example main.tf -->
```hcl
module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
}

module "flow_logs" {
  source  = "dflook/vpc-network/aws//modules/cloudwatch_flow_logs"
  version = "1.0.0"

  vpc               = module.vpc.vpc
  retention_in_days = 7
}
```
<!-- end example -->
