# VPC flow logs modules

This module configures flow logs for a vpc that go to a cloudwatch log group.

The log group will be created, but not deleted when the group is destroyed.
<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>=1.3.2)

- aws (>=4.0)

## Resources

The following resources are used by this module:

- [aws_cloudwatch_log_group.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) (resource)
- [aws_flow_log.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) (resource)
- [aws_iam_role.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) (resource)

## Required Inputs

The following input variables are required:

### vpc

Description: Structured information about the VPC to create the subnets in.

Typically this is the `vpc` output of the `vpc` module.

Example:
```
{
  id          = "vpc-1234567890abcdef0"
  name        = "my-vpc"
  region_name = "us-west-2"
}
```

Type:

```hcl
object({
    id          = string
    name        = string
    region_name = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### name

Description: The name of the flow log. It will be prefixed with the VPC name.

Type: `string`

Default: `"flow-log"`

### retention\_in\_days

Description: The number of days to retain the flow logs for.

Type: `number`

Default: `30`

### tags

Description: A map of tags to add to all resources.

Type: `map(string)`

Default: `{}`
<!-- END_TF_DOCS -->