variable "name" {
  description = "The name of the nat gateway"
  type        = string
  default     = "nat"

  validation {
    condition     = length(var.name) >= 1
    error_message = "Name must not be empty."
  }

  validation {
    condition     = length(var.name) <= 120
    error_message = "Name must not be longer than 120 characters."
  }
}

variable "vpc" {
  description = <<-EOT
    Structured information about the VPC to create the nat gateway in.

    Typically this is the `vpc` output of the `vpc` module.

    Example:

    ```hcl
    vpc = {
      name = "my-vpc"
    }
    ```
  EOT

  type = object({
    name = string
  })

  validation {
    condition     = length(var.vpc.name) >= 1
    error_message = "Name must not be empty."
  }

  validation {
    condition     = length(var.vpc.name) <= 120
    error_message = "Name must not be longer than 120 characters."
  }
}

variable "public_subnet" {
  description = <<-EOT
    The subnet to create the NAT gateway in

    Typically a value from the `subnets` output of the `subnets` modules.

    Example:
    ```hcl
    {
      availability_zone = "a"
      id                = "subnet-12345678"
    }
    ```
  EOT

  type = object({
    availability_zone = string
    id                = string
  })

  validation {
    condition     = startswith(var.public_subnet.id, "subnet-")
    error_message = "Subnet ID must be a valid subnet ID."
  }

  validation {
    condition     = contains(["a", "b", "c", "d"], var.public_subnet.availability_zone)
    error_message = "Availability zone must be in the format 'a', 'b', 'c', 'd'."
  }
}

variable "private_subnets" {
  description = <<-EOT
    The subnets to add the NAT gateway route to.

    Typically these are values from the `subnets` output of `subnets` modules.

    Example:
    ```hcl
    [
      {
        id                     = "subnet-12345678"
        availability_zone      = "a"
        availability_zone_id   = "usw2-az1"
        availability_zone_name = "us-west-2a"
        cidr_block             = "10.145.0.0/16"
        network_acl_id         = "acl-12345678"
        route_table_id         = "rtb-12345678"
        name                   = "subnet-a"
      }
    ]
    ```
  EOT

  type = list(object({
    availability_zone = string
    id                = string
    route_table_id    = string
    name              = string
  }))

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : contains(["a", "b", "c", "d"], subnet.availability_zone)
    ])
    error_message = "Availability zones must be in the format ['a', 'b', 'c', 'd']."
  }

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs must be valid subnet IDs."
  }

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : startswith(subnet.route_table_id, "rtb-")
    ])
    error_message = "Route table IDs must be valid route table IDs."
  }

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : length(subnet.name) > 0
    ])
    error_message = "Name must not be empty."
  }

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : length(subnet.name) <= 120
    ])
    error_message = "Name must not be longer than 120 characters."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

locals {
  tags = merge(
    var.tags,
    {
      TerraformModule = "dflook/vpc-network/aws//modules/nat-gateway"
    }
  )
}
