resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  tags = merge(
    local.tags,
    {
      Name = "${var.name}_default"
    }
  )
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = merge(
    local.tags,
    {
      Name = "${var.name}_default"
    }
  )
}

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      Name = "${var.name}_default"
    }
  )
}
