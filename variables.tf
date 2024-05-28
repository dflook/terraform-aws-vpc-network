variable "name" {
  description = <<-EOT
    The name of the VPC. Must be unique within the AWS account.
  EOT

  type    = string
  default = "vpc"

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
  EOT

  type    = string
  default = "10.0.0.0/16"

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

variable "tags" {
  description = "A map of tags to apply to all resources."

  type    = map(string)
  default = {}
}
