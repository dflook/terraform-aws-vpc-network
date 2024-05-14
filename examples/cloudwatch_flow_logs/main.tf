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
