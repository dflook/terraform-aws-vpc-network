variable "name" {
  description = <<-EOT
    The name of the subnets to create.

    Each subnet name will be prefixed with the vpc name and suffixed with the availability zone.
  EOT

  type    = string
  default = "aws_endpoints"

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

    Example: `"10.0.0.0/28"`
  EOT

  type = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 1))
    error_message = "Invalid CIDR block."
  }
}

variable "aws_interface_vpc_endpoints" {
  description = <<-EOT
    A list of AWS services to create AWS VPC Interface Endpoints for.

    The full list of available aws services can be found at:
    https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html

    Example: `["ec2", "sns"]`
  EOT

  type    = set(string)
  default = []

  validation {
    condition     = alltrue([for service in var.aws_interface_vpc_endpoints : service != ""])
    error_message = "AWS endpoints must not be empty strings."
  }
}

variable "routed_subnets" {
  description = <<-EOT
    Subnets that should have routes to the AWS gateway endpoints

    Typically the values from the `subnets` output of `subnets` modules.

    Example:
    ```hcl
    [
      {
        route_table_id = "rtb-12345678"
        name           = "subnet-a"
      }
    ]
  EOT

  type = list(object({
    name           = string
    route_table_id = string
  }))

  default = []

  validation {
    condition     = alltrue([for subnet in var.routed_subnets : startswith(subnet.route_table_id, "rtb-")])
    error_message = "Route Table id is not in the expected format."
  }

  validation {
    condition     = alltrue([for subnet in var.routed_subnets : length(subnet.name) > 0])
    error_message = "Name should not be empty."
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
      cidr_block  = "10.145.0.0/16"
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
  description = "A map of tags to apply to all resources."

  type    = map(string)
  default = {}
}

locals {
  tags = merge(
    var.tags,
    {
      TerraformModule = "dflook/vpc-network/aws//modules/aws_endpoints"
    }
  )
}
