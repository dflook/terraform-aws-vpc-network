# AWS VPC Module

This module creates a VPC. It is designed to be composable with other modules in this repository.

The default VPC resources are brought into management by this module. This includes the default route table, security group, and network ACL.
They are intentionally kept empty and unusable.

## Usage

```hcl
module "vpc" {
  source  = "dflook/vpc-network/aws//modules/vpc"
  version = "1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Resources

The following resources are used by this module:

- [aws_default_network_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) (resource)
- [aws_default_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) (resource)
- [aws_default_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) (resource)
- [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (resource)
- [aws_vpc_ipv4_cidr_block_association.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) (resource)

## Required Inputs

The following input variables are required:

### name

Description: The name of the VPC. Must be unique within the AWS account.

Example: `"my-vpc"`

Type: `string`

### cidr\_block

Description: The CIDR block for the VPC.

Example: `"10.0.0.0/16"`

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### secondary\_cidr\_blocks

Description: Secondary CIDR blocks for the VPC.

Example: `["192.168.1.0/24"]`

Type: `list(string)`

Default: `[]`

### tags

Description: A map of tags to apply to all resources.

Type: `map(string)`

Default: `{}`

### vpc\_tags

Description: Additional map of tags to apply to the aws\_vpc resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### name

Description: The name of the VPC.

Type: `string`

Example: `"my-vpc"`

### id

Description: The ID of the VPC.

Type: `string`

Example: `"vpc-12345678"`

### cidr\_block

Description: The CIDR block of the VPC.

Type: `string`

Example: `"10.0.0.0/16"`

### secondary\_cidr\_blocks

Description: Secondary CIDR blocks for the VPC.

Type: `list(string)`

Example: `["192.168.1.0/24"]`

### vpc

Description: Structured information about the VPC.

Type:

```hcl
object({
    id                    = string
    name                  = string
    cidr_block            = string
    secondary_cidr_blocks = list(string)
    region_name           = string
})
```

Example:

```hcl
{
    id                    = "vpc-123456"
    name                  = "my-vpc"
    cidr_block            = "10.0.0.0/16"
    secondary_cidr_blocks = ["192.168.0.0/24"]
    region_name           = "us-west-2"
}
```
<!-- END_TF_DOCS -->

## Examples

For examples see the [examples](https://github.com/dflook/terraform-aws-vpc-network/tree/main/examples) directory.