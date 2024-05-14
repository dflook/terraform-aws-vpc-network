variable "name" {
  description = <<-EOT
    The name of the VPC. Must be unique within the AWS account.

    Example: `"my-vpc"`
  EOT

  type = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "Name must not be empty."
  }

  validation {
    condition     = length(var.name) <= 120
    error_message = "Name must not be longer than 120 characters."
  }
}

variable "cidr_block" {
  description = <<-EOT
    The CIDR block for the VPC.

    Example: `"10.0.0.0/16"`
  EOT

  type = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 1))
    error_message = "Invalid CIDR block."
  }
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional map of tags to apply to the aws_vpc resource."
  type        = map(string)
  default     = {}
}

locals {
  tags = merge(
    var.tags,
    {
      TerraformModule = "dflook/vpc-network/aws//modules/vpc"
    }
  )
}
