output "name" {
  description = <<-EOT
    The name of the VPC.

    Type: `string`

    Example: `"my-vpc"`
  EOT

  value = aws_vpc.vpc.tags.Name

  precondition {
    condition     = length(aws_vpc.vpc.tags.Name) > 0
    error_message = "The VPC did not have a Name tag set."
  }

  precondition {
    condition     = aws_vpc.vpc.tags.Name == var.name
    error_message = "The VPC did not have the expected Name tag value."
  }
}

output "id" {
  description = <<-EOT
  The ID of the VPC.

  Type: `string`

  Example: `"vpc-12345678"`
EOT

  value = aws_vpc.vpc.id

  precondition {
    condition     = startswith(aws_vpc.vpc.id, "vpc-")
    error_message = "The VPC ID was not in the expected format."
  }
}

output "cidr_block" {
  description = <<-EOT
    The CIDR block of the VPC.

    Type: `string`

    Example: `"10.0.0.0/16"`
EOT

  value = aws_vpc.vpc.cidr_block

  precondition {
    condition     = can(cidrhost(aws_vpc.vpc.cidr_block, 1))
    error_message = "VPC CIDR block was not set correctly."
  }

  precondition {
    condition     = var.cidr_block == aws_vpc.vpc.cidr_block
    error_message = "VPC CIDR block was not set correctly."
  }
}

output "vpc" {
  description = <<-EOT
    Structured information about the VPC.

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
  EOT

  value = {
    id          = aws_vpc.vpc.id
    name        = aws_vpc.vpc.tags.Name
    cidr_block  = aws_vpc.vpc.cidr_block
    region_name = data.aws_region.current.name
  }

  precondition {
    condition     = length(aws_vpc.vpc.tags.Name) > 0
    error_message = "The VPC did not have a Name tag set."
  }

  precondition {
    condition     = startswith(aws_vpc.vpc.id, "vpc-")
    error_message = "The VPC ID was not in the expected format."
  }

  precondition {
    condition     = can(cidrhost(aws_vpc.vpc.cidr_block, 1))
    error_message = "VPC CIDR block was not set correctly."
  }

  precondition {
    condition     = var.cidr_block == aws_vpc.vpc.cidr_block
    error_message = "VPC CIDR block was not set correctly."
  }

  precondition {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]$", data.aws_region.current.name))
    error_message = "Region name is not in the expected format."
  }
}