# AWS Endpoints Module

This add AWS service endpoints to a VPC.

Gateway VPC Endpoints for S3 and DynamoDB are always created. Use the `routed_subnets` input variable to specify the subnets to associate with the gateway endpoints.

Interface endpoints are created for the services specified in the `aws_services` variable.
Allow access from source security groups by adding a rule to the security group in the `security_group_id` output.

## Usage

```hcl
module "aws_endpoints" {
  source  = "dflook/vpc-network/aws//modules/aws_endpoints"
  version = "1.0.0"

  cidr_block         = local.aws_endpoints_cidr_block
  vpc                = module.vpc.vpc
  availability_zones = local.availability_zones

  routed_subnets = concat(
    values(module.public_subnets.subnets),
    values(module.private_subnets.subnets)
  )

  aws_interface_vpc_endpoints = ["ec2", "sqs"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Resources

The following resources are used by this module:

- [aws_network_acl.aws_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) (resource)
- [aws_network_acl_association.aws_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) (resource)
- [aws_route_table.aws_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) (resource)
- [aws_route_table_association.aws_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) (resource)
- [aws_security_group.vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_subnet.aws_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) (resource)
- [aws_vpc_endpoint.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) (resource)
- [aws_vpc_endpoint.interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) (resource)
- [aws_vpc_endpoint_route_table_association.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) (resource)
- [aws_vpc_endpoint_route_table_association.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) (resource)

## Required Inputs

The following input variables are required:

### cidr\_block

Description: The CIDR block to create the subnets in.

The block will be split into equal parts for each availability zone.

Example: `"10.0.0.0/28"`

Type: `string`

### availability\_zones

Description: Availability zones to create the subnets in.

Example: `["a", "b", "c"]`

Type: `set(string)`

### vpc

Description: Structured information about the VPC to create the subnets in.

Typically this is the `vpc` output of the `vpc` module.

Example:
```
{
  id                    = "vpc-1234567890abcdef0"
  name                  = "my-vpc"
  cidr_block            = "10.145.0.0/16"
  secondary_cidr_blocks = ["192.168.0.1/24"]
  region_name           = "us-west-2"
}
```

Type:

```hcl
object({
    id                    = string
    name                  = string
    cidr_block            = string
    secondary_cidr_blocks = optional(list(string), [])
    region_name           = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### name

Description: The name of the subnets to create.

Each subnet name will be prefixed with the vpc name and suffixed with the availability zone.

Type: `string`

Default: `"aws_endpoints"`

### aws\_interface\_vpc\_endpoints

Description: A list of AWS services to create AWS VPC Interface Endpoints for.

The full list of available aws services can be found at:  
https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html

Example: `["ec2", "sns"]`

Type: `set(string)`

Default: `[]`

### routed\_subnets

Description: Subnets that should have routes to the AWS gateway endpoints

Typically the values from the `subnets` output of `subnets` modules.

Example:
```hcl
[
  {
    route_table_id = "rtb-12345678"
    name           = "subnet-a"
  }
]
```

Type:

```hcl
list(object({
    name           = string
    route_table_id = string
  }))
```

Default: `[]`

### tags

Description: A map of tags to apply to all resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### interface\_endpoint\_sg

Description: The security group ID for the interface endpoints.

This is the security group used by the Interface VPC Endpoints, and may be used in security group rules to allow traffic.

Type: `string`

Example: `"sg-0123456789abcdef0"`

### subnets

Description: A map of availability zone to structured subnet information.

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
    name                   = "subnet-a"
  }
}
```
<!-- END_TF_DOCS -->

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.