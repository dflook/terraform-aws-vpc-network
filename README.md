# AWS VPC Terraform Modules

This collection of modules is used to create and manage AWS VPCs.

The modules are designed to be composable, allowing you to use them together in different combinations to create different infrastructure setups.

This collection includes the following modules:
- [VPC](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/vpc)
- [Subnets](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/subnets)
- [Internet Gateway](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/internet_gateway)
- [NAT Gateway](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/nat_gateway)
- [CloudWatch Flow Logs](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/cloudwatch_flow_logs)
- [AWS Endpoint Subnets](https://registry.terraform.io/modules/dflook/vpc-network/aws/latest/submodules/aws_endpoints)

This parent module can be used to create a generic VPC.
If this doesn't meet your requirements, you can use it as an example to create your own VPC module using the individual submodules.

This module creates a VPC across the specified availability zones.
The VPC has:
- public subnets with a route to the internet through a internet gateway
- private subnets with a route to the internet through a NAT gateway
- internal subnets with no route to the internet
- These subnets also have routes to dynamodb and s3 Gateway VPC interface endpoints
- aws_endpoint subnets with VPC Interface endpoints for the specified AWS services, and a security group that can be used in security group rules to allow traffic to the endpoints.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Required Inputs

The following input variables are required:

### availability\_zones

Description: Availability zones to create the subnets in.

Example: `["a", "b", "c"]`

Type: `set(string)`

## Optional Inputs

The following input variables are optional (have default values):

### name

Description: The name of the VPC. Must be unique within the AWS account.

Type: `string`

Default: `"vpc"`

### cidr\_block

Description: The CIDR block for the VPC.

Type: `string`

Default: `"10.0.0.0/16"`

### aws\_interface\_vpc\_endpoints

Description: A list of AWS services to create AWS VPC Interface Endpoints for.

The full list of available aws services can be found at:  
https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html

Example: `["ec2", "sns"]`

Type: `set(string)`

Default: `[]`

### tags

Description: A map of tags to apply to all resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### vpc

Description: Structured information about the VPC.

Type:

```hcl
object({
    id          = string,
    name        = string,
    cidr_block  = string,
    region_name = string
})
```

Example:

```hcl
{
    id          = "vpc-123456"
    name        = "my-vpc",
    cidr_block  = "10.0.0.0/16",
    region_name = "us-west-2"
}
```

### public\_subnets

Description: Structured information about the public subnets.

This is a map of availability zone index to subnet information.

Type:
```hcl
map(object({
  id                     = string
  availability_zone      = string
  availability_zone_id   = string
  availability_zone_name = string
  cidr_block             = string
  network_acl_id         = string
  route_table_id         = string
  name                   = string
}))
```

Example:
```hcl
{
  a = {
    id                     = "subnet-12345678"
    availability_zone      = "a"
    availability_zone_id   = "usw2-az1"
    availability_zone_name = "us-west-2a"
    cidr_block             = "10.145.0.0/16"
    network_acl_id         = "acl-12345678"
    route_table_id         = "rtb-12345678"
    name                   = "my-vpc_public_a"
  }
}
```

### private\_subnets

Description: Structured information about the public subnets.

This is a map of availability zone index to subnet information.

Type:
```hcl
map(object({
  id                     = string
  availability_zone      = string
  availability_zone_id   = string
  availability_zone_name = string
  cidr_block             = string
  network_acl_id         = string
  route_table_id         = string
  name                   = string
}))
```

Example:
```hcl
{
  a = {
    id                     = "subnet-12345678"
    availability_zone      = "a"
    availability_zone_id   = "usw2-az1"
    availability_zone_name = "us-west-2a"
    cidr_block             = "10.145.0.0/16"
    network_acl_id         = "acl-12345678"
    route_table_id         = "rtb-12345678"
    name                   = "my-vpc_private_a"
  }
}
```

### aws\_interface\_endpoint\_sg

Description: The security group ID of the interface endpoints.

This can be referenced in security group rules to allow access to the VPC Interface Endpoints for the AWS services specified in the `aws_interface_vpc_endpoints` variable.

Type: `string`

Example: `"sg-0123456789abcdef0"`
<!-- END_TF_DOCS -->

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.