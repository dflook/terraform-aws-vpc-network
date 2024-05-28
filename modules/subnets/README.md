# AWS Subnets module

This module creates a set of equivalent subnets in different availability zones.

Each subnet in the set has a unique part of the cidr block specified in the `cidr_block` input variable.
Each subnet has a unique route table.
There is one network acl used by all the subnets.

## Usage

```hcl
module "my_subnets" {
  source  = "dflook/vpc-network/aws//modules/subnets"
  version = "1.0.0"

  vpc = module.my_vpc.vpc

  name       = "public"
  cidr_block = "10.0.0.0/20"

  availability_zones = ["a", "b"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0.0)

## Resources

The following resources are used by this module:

- [aws_network_acl.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) (resource)
- [aws_network_acl_association.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) (resource)
- [aws_network_acl_rule.egress_allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) (resource)
- [aws_network_acl_rule.ingress_allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) (resource)
- [aws_route_table.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) (resource)
- [aws_route_table_association.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) (resource)
- [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) (resource)

## Required Inputs

The following input variables are required:

### name

Description: The name of the subnets to create.

Each subnet name will be prefixed with the vpc name and suffixed with the availability zone.

Example: `"public"`

Type: `string`

### cidr\_block

Description: The CIDR block to create the subnets in.

The block will be split into equal parts for each availability zone.

Example: `"10.0.0.0/20"`

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
  id          = "vpc-1234567890abcdef0"
  name        = "my-vpc"
  cidr_block  = "10.0.0.0/16"
  region_name = "us-west-2"
}
```

Type:

```hcl
object({
    id          = string
    name        = string
    cidr_block  = string
    region_name = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### tags

Description: A map of tags to add to all resources.

Type: `map(string)`

Default: `{}`

### subnet\_tags

Description: Additional map of tags to apply to the aws\_subnet resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### subnets

Description: A map of availability zone index to structured subnet information.

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

### network\_acl\_id

Description: The ID of the network ACL.

Type: `string`

Example: `"acl-12345678"`
<!-- END_TF_DOCS -->

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.