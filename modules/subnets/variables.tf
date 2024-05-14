variable "name" {
  description = <<-EOT
    The name of the subnets to create.

    Each subnet name will be prefixed with the vpc name and suffixed with the availability zone.

    Example: `"public"`
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
    The CIDR block to create the subnets in.

    The block will be split into equal parts for each availability zone.

    Example: `"10.0.0.0/20"`
  EOT

  type = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 1))
    error_message = "Invalid CIDR block."
  }
}

variable "availability_zones" {
  description = <<-EOT
    Availability zones to create the subnets in.

    Example: `["a", "b", "c"]`
  EOT

  type = set(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be provided."
  }

  validation {
    condition     = length(var.availability_zones) <= 4
    error_message = "No more than 4 availability zones can be provided."
  }

  validation {
    condition     = alltrue([for zone in var.availability_zones : contains(["a", "b", "c", "d"], zone)])
    error_message = "Availability zones must be in the format ['a', 'b', 'c']."
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
      cidr_block  = "10.0.0.0/16"
      region_name = "us-west-2"
    }
    ```
  EOT

  type = object({
    id          = string
    name        = string
    cidr_block  = string
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
    condition     = can(cidrhost(var.vpc.cidr_block, 1))
    error_message = "Invalid CIDR block."
  }

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]$", var.vpc.region_name))
    error_message = "Region name must be in the format 'us-west-2'."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "subnet_tags" {
  description = "Additional map of tags to apply to the aws_subnet resources."
  default     = {}
  type        = map(string)
}

locals {
  tags = merge(
    var.tags,
    {
      TerraformModule = "dflook/vpc-network/aws//modules/subnets"
    }
  )
}
