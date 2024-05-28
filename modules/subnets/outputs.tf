output "subnets" {
  description = <<-EOT
    A map of availability zone index to structured subnet information.

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
    id                     = aws_subnet.subnet[zone].id
    availability_zone      = zone
    availability_zone_id   = aws_subnet.subnet[zone].availability_zone_id
    availability_zone_name = aws_subnet.subnet[zone].availability_zone
    cidr_block             = aws_subnet.subnet[zone].cidr_block
    network_acl_id         = aws_network_acl.subnet.id
    route_table_id         = aws_route_table.subnet[zone].id
    name                   = aws_subnet.subnet[zone].tags.Name
  } }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : contains(["a", "b", "c", "d"], zone)
    ])
    error_message = "Zone indexes were not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : startswith(subnet.id, "subnet-")
    ])
    error_message = "Subnet IDs were not in the expected format."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : can(regex("^[a-z]+-[a-z]+-[0-9][a-z]$", subnet.availability_zone))
    ])
    error_message = "availability_zone_name is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : can(cidrhost(subnet.cidr_block, 1))
    ])
    error_message = "cidr_block is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : startswith(aws_network_acl.subnet.id, "acl-")
    ])
    error_message = "network_acl_id is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : startswith(aws_route_table.subnet[zone].id, "rtb-")
    ])
    error_message = "route_table is not as expected."
  }

  precondition {
    condition = alltrue([
      for zone, subnet in aws_subnet.subnet : length(subnet.tags.Name) > 0
    ])
    error_message = "Name must not be empty."
  }
}

output "network_acl_id" {
  description = <<-EOT
    The ID of the network ACL.

    Type: `string`

    Example: `"acl-12345678"`
  EOT

  value = aws_network_acl.subnet.id

  precondition {
    condition     = startswith(aws_network_acl.subnet.id, "acl-")
    error_message = "Network ACL ID was not in the expected format."
  }
}
