output "interface_endpoint_sg" {
  description = <<-EOT
    The security group ID for the interface endpoints.

    This is the security group used by the Interface VPC Endpoints, and may be used in security group rules to allow traffic.

    Type: `string`

    Example: `"sg-0123456789abcdef0"`
  EOT

  value = aws_security_group.vpc_endpoint.id

  precondition {
    condition     = startswith(aws_security_group.vpc_endpoint.id, "sg-")
    error_message = "Security Group ID not in the expected format."
  }
}

output "subnets" {
  description = <<-EOT
    A map of availability zone to structured subnet information.

    Type:
    ```hcl
    map(object({
      id                     = string
      availability_zone      = string
      availability_zone_id   = string
      availability_zone_name = string
      cidr_block             = string
      network_acl_id         = string
      route_table_id         = string
      name                   = string
    }))
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
        name                   = "subnet-a"
      }
    }
    ```
  EOT


  value = { for zone in var.availability_zones : zone => {
    id                     = aws_subnet.aws_endpoints[zone].id
    availability_zone      = zone
    availability_zone_id   = aws_subnet.aws_endpoints[zone].availability_zone_id
    availability_zone_name = aws_subnet.aws_endpoints[zone].availability_zone
    cidr_block             = aws_subnet.aws_endpoints[zone].cidr_block
    network_acl_id         = aws_network_acl.aws_endpoints.id
    route_table_id         = aws_route_table.aws_endpoints[zone].id
    name                   = aws_subnet.aws_endpoints[zone].tags.Name
  } }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : contains(["a", "b", "c", "d"], zone)
    ])
    error_message = "Zone indexes were not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs were not in the expected format."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : can(regex("^[a-z]+-[a-z]+-[0-9][a-z]$", subnet.availability_zone))
    ])
    error_message = "availability_zone_name is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : can(cidrhost(subnet.cidr_block, 1))
    ])
    error_message = "cidr_block is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : startswith(aws_network_acl.aws_endpoints.id, "acl-")
    ])
    error_message = "network_acl_id is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : startswith(aws_route_table.aws_endpoints[zone].id, "rtb-")
    ])
    error_message = "route_table is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.aws_endpoints : length(subnet.tags.Name) > 0
    ])
    error_message = "Name must not be empty."
  }
}