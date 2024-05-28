# Internet Gateway Module

This module creates an internet gateway and adds a route to it in the route tables of the specified subnets.

## Usage

```hcl
module "internet_gateway" {
  source  = "dflook/vpc-network/aws//modules/internet_gateway"
  version = "1.0.0"

  vpc            = module.vpc.vpc
  public_subnets = module.public_subnets.subnets
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Resources

The following resources are used by this module:

- [aws_internet_gateway.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) (resource)
- [aws_route.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) (resource)

## Required Inputs

The following input variables are required:

### vpc

Description: Structured information about the VPC to create the subnets in.

Typically this is the `vpc` output of the `vpc` module.

Example:
```
{
  id   = "vpc-1234567890abcdef0"
  name = "my-vpc"
}
```

Type:

```hcl
object({
    id   = string
    name = string
  })
```

### public\_subnets

Description: The subnets to create a route table association for.

Typically the `subnets` output of a `subnets` module.

Example:
```
{
  a = {
    id             = "subnet-12345678"
    route_table_id = "rtb-12345678"
  }
}
```

Type:

```hcl
map(object({
    id             = string,
    route_table_id = string
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

### tags

Description: A map of tags to add to all resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### internet\_gateway\_id

Description: The ID of the internet gateway

Example: `"igw-12345678"`
<!-- END_TF_DOCS -->

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.