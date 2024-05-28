# Nat Gateway Module

This module creates a NAT Gateway in the specified public subnet.

Route tables for the specified private subnets are updated to route traffic through the NAT Gateway.

## Usage

```hcl
module "nat_gateway" {
  for_each = toset(local.availability_zones)

  source  = "dflook/vpc-network/aws//modules/nat_gateway"
  version = "1.0.0"

  vpc           = module.vpc.vpc
  public_subnet = module.public_subnets.subnets[each.key]
  private_subnets = [
    module.private_subnets.subnets[each.key]
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Resources

The following resources are used by this module:

- [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) (resource)
- [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) (resource)
- [aws_route.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) (resource)

## Required Inputs

The following input variables are required:

### vpc

Description: Structured information about the VPC to create the nat gateway in.

Typically this is the `vpc` output of the `vpc` module.

Example:

```hcl
vpc = {
  name = "my-vpc"
}
```

Type:

```hcl
object({
    name = string
  })
```

### public\_subnet

Description: The subnet to create the NAT gateway in

Typically a value from the `subnets` output of the `subnets` modules.

Example:
```hcl
{
  availability_zone = "a"
  id                = "subnet-12345678"
}
```

Type:

```hcl
object({
    availability_zone = string
    id                = string
  })
```

### private\_subnets

Description: The subnets to add the NAT gateway route to.

Typically these are values from the `subnets` output of `subnets` modules.

Example:
```hcl
[
  {
    id                     = "subnet-12345678"
    availability_zone      = "a"
    route_table_id         = "rtb-12345678"
    name                   = "subnet-a"
  }
]
```

Type:

```hcl
list(object({
    availability_zone = string
    id                = string
    route_table_id    = string
    name              = string
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

### name

Description: The name of the nat gateway

Type: `string`

Default: `"nat"`

### tags

Description: A map of tags to add to all resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### nat\_gateway\_id

Description: The ID of the NAT Gateway.

Type: `string`

Example: `"nat-0a1234567890abcdef"`

### nat\_gateway\_egress\_ip

Description: The public IP address of the NAT Gateway.

This is the IP address that is used for egress traffic from the private subnets.

Type: `string`

Example: `"192.0.2.0"`
<!-- END_TF_DOCS -->

## Examples

### A NAT gateway for each availability zone

```hcl
module "vpc" {
  source = "github.com/dflook/terraform-aws-vpc//modules/vpc?ref=1.0.0"

  name        = "my-vpc"
  cidr_block  = "10.145.0.0/16"
}

module "public_subnet" {
  source = "github.com/dflook/terraform-aws-vpc//modules/subnets?ref=1.0.0"
    
  vpc_id         = module.vpc.id
  name           = "public"
  cidr_block     = "10.145.1.0/24"
  availability_zones = ["a", "b", "c"]
}

module "private_subnets" {
  source = "github.com/dflook/terraform-aws-vpc//modules/subnets?ref=1.0.0"
  
  vpc_id             = module.vpc.id
  name               = "public"
  cidr_block         = "10.145.1.0/24"
  availability_zones = ["a", "b", "c"]
}

module "nat_gateway" {
  source = "github.com/dflook/terraform-aws-vpc//modules/nat_gateway?ref=1.0.0"
    
  vpc            = module.vpc.vpc
  public_subnet  = module.public_subnet["a"].subnet
  private_subnets = [
      module.private_subnet["a"].subnet,
  ]
}
```

### A single NAT Gateway for all private subnets

```hcl
module "vpc" {
  source = "github.com/dflook/terraform-aws-vpc//modules/vpc?ref=1.0.0"

  name        = "my-vpc"
  cidr_block  = "10.145.0.0/16"
}

module "public_subnet" {
  source = "github.com/dflook/terraform-aws-vpc//modules/subnets?ref=1.0.0"
    
  vpc_id         = module.vpc.id
  name           = "public"
  cidr_block     = "10.145.1.0/24"
  availability_zones = ["a"]
}

module "private_subnets" {
  source = "github.com/dflook/terraform-aws-vpc//modules/subnets?ref=1.0.0"
  
  vpc_id             = module.vpc.id
  name               = "public"
  cidr_block         = "10.145.1.0/24"
  availability_zones = ["a", "b", "c"]
}

module "nat_gateway" {
  source = "github.com/dflook/terraform-aws-vpc//modules/nat_gateway?ref=1.0.0"
    
  vpc            = module.vpc.vpc
  public_subnet  = module.public_subnet.subnets["a"]
  private_subnets = module.private_subnet.subnets
}
```

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.