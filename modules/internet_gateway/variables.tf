variable "vpc" {
  description = <<-EOT
    Structured information about the VPC to create the subnets in.

    Typically this is the `vpc` output of the `vpc` module.

    Example:
    ```
    {
      id   = "vpc-1234567890abcdef0"
      name = "my-vpc"
    }
    ```
  EOT

  type = object({
    id   = string
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

  validation {
    condition     = startswith(var.vpc.id, "vpc-")
    error_message = "VPC ID must start with 'vpc-'."
  }
}

variable "public_subnets" {
  description = <<-EOT
    The subnets to create a route table association for.

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
  EOT

  type = map(object({
    id             = string,
    route_table_id = string
  }))

  validation {
    condition = alltrue([
      for zone, subnet in var.public_subnets : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs were not in the expected format."
  }

  validation {
    condition = alltrue([
      for zone, subnet in var.public_subnets : startswith(subnet.route_table_id, "rtb-")
    ])
    error_message = "Route table IDs were not in the expected format."
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
      TerraformModule = "dflook/vpc-network/aws//modules/internet-gateway"
    }
  )
}
