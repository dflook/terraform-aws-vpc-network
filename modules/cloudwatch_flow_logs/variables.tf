variable "name" {
  description = "The name of the flow log. It will be prefixed with the VPC name."

  type    = string
  default = "flow-log"

  validation {
    condition     = length(var.name) >= 1
    error_message = "Name must not be empty."
  }

  validation {
    condition     = length(var.name) <= 120
    error_message = "Name must not be longer than 120 characters."
  }
}

variable "retention_in_days" {
  description = "The number of days to retain the flow logs for."

  type    = number
  default = 30

  validation {
    condition     = var.retention_in_days != 0
    error_message = "Don't retain flow logs forever."
  }
}

variable "vpc" {
  description = <<-EOT
    Structured information about the VPC to create the subnets in.

    Typically this is the `vpc` output of the `vpc` module.

    Example:
    ```
    {
      id          = "vpc-1234567890abcdef0"
      name        = "my-vpc"
      region_name = "us-west-2"
    }
    ```
  EOT

  type = object({
    id          = string
    name        = string
    region_name = string
  })

  validation {
    condition     = length(var.vpc.name) >= 1
    error_message = "Name must not be empty."
  }

  validation {
    condition     = length(var.vpc.name) <= 120
    error_message = "Name must not be longer than 120 characters."
  }

  validation {
    condition     = startswith(var.vpc.id, "vpc-")
    error_message = "VPC ID must start with 'vpc-'."
  }

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]$", var.vpc.region_name))
    error_message = "Region name must be in the format 'us-west-2'."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."

  type    = map(string)
  default = {}
}

locals {
  tags = merge(
    var.tags,
    {
      TerraformModule = "dflook/vpc-network/aws//modules/cloudwatch_flow_logs"
    }
  )
}
