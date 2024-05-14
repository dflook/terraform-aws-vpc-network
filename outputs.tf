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

  value = module.vpc.vpc

  precondition {
    condition     = length(module.vpc.vpc.name) > 0
    error_message = "The VPC did not have a Name tag set."
  }

  precondition {
    condition     = startswith(module.vpc.vpc.id, "vpc-")
    error_message = "The VPC ID was not in the expected format."
  }

  precondition {
    condition     = can(cidrhost(module.vpc.vpc.cidr_block, 1))
    error_message = "VPC CIDR block was not set correctly."
  }

  precondition {
    condition     = var.cidr_block == module.vpc.vpc.cidr_block
    error_message = "VPC CIDR block was not set correctly."
  }

  precondition {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]$", module.vpc.vpc.region_name))
    error_message = "Region name is not in the expected format."
  }
}

output "public_subnets" {
  description = <<-EOT
    Structured information about the public subnets.

    This is a map of availability zone index to subnet information.

    Type:
    ```hcl
    object({
      id                     = string
      availability_zone      = string
      availability_zone_id   = string
      availability_zone_name = string
      cidr_block             = string
      network_acl_id         = string
      route_table_id         = string
      name                   = string
    })
    ```

    Example:
    ```hcl
    {
      a = {
        id                     = "subnet-12345678"
        availability_zone      = "a"
        availability_zone_id   = "usw2-az1"
        availability_zone_name = "us-west-2a"
        cidr_block             = "10.145.0.0/16"
        network_acl_id         = "acl-12345678"
        route_table_id         = "rtb-12345678"
        name                   = "my-vpc_public_a"
      }
    }
    ```
  EOT

  value = module.public_subnets.subnets

  precondition {
    condition = alltrue([
      for zone, subnet in module.public_subnets.subnets : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs were not in the expected format."
  }

}

output "private_subnets" {
  description = <<-EOT
    Structured information about the public subnets.

    This is a map of availability zone index to subnet information.

    Type:
    ```hcl
    object({
      id                     = string
      availability_zone      = string
      availability_zone_id   = string
      availability_zone_name = string
      cidr_block             = string
      network_acl_id         = string
      route_table_id         = string
      name                   = string
    })
    ```

    Example:
    ```hcl
    {
      a = {
        id                     = "subnet-12345678"
        availability_zone      = "a"
        availability_zone_id   = "usw2-az1"
        availability_zone_name = "us-west-2a"
        cidr_block             = "10.145.0.0/16"
        network_acl_id         = "acl-12345678"
        route_table_id         = "rtb-12345678"
        name                   = "my-vpc_private_a"
      }
    }
    ```
  EOT

  value = module.private_subnets.subnets

  precondition {
    condition = alltrue([
      for zone, subnet in module.private_subnets.subnets : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs were not in the expected format."
  }
}

output "aws_interface_endpoint_sg" {
  description = <<-EOT
    The security group ID of the interface endpoints.

    This can be referenced in security group rules to allow access to the VPC Interface Endpoints for the AWS services specified in the `aws_interface_vpc_endpoints` variable.

    Type: string

    Example: `"sg-0123456789abcdef0"`
  EOT

  value = module.aws_endpoints.interface_endpoint_sg

  precondition {
    condition     = startswith(module.aws_endpoints.interface_endpoint_sg, "sg-")
    error_message = "Security group ID was not in the expected format."
  }
}
