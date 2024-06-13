resource "aws_network_acl" "aws_endpoints" {
  vpc_id = var.vpc.id

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}"
    },
    local.tags
  )

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = var.vpc.cidr_block
    action     = "allow"
  }

  egress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 0
    to_port    = 65535
    cidr_block = var.vpc.cidr_block
    action     = "allow"
  }

  dynamic "ingress" {
    for_each = zipmap(range(length(var.vpc.secondary_cidr_blocks)), var.vpc.secondary_cidr_blocks)

    content {
      rule_no    = 101 + ingress.key
      protocol   = "tcp"
      from_port  = 443
      to_port    = 443
      cidr_block = ingress.value
      action     = "allow"
    }
  }

  dynamic "egress" {
    for_each = zipmap(range(length(var.vpc.secondary_cidr_blocks)), var.vpc.secondary_cidr_blocks)

    content {
      rule_no    = 101 + egress.key
      protocol   = "tcp"
      from_port  = 0
      to_port    = 65535
      cidr_block = egress.value
      action     = "allow"
    }
  }
}

resource "aws_network_acl_association" "aws_endpoints" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.aws_endpoints[each.key].id
  network_acl_id = aws_network_acl.aws_endpoints.id
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id      = var.vpc.id
  name        = var.name
  description = "AWS VPC Endpoints"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = concat([var.vpc.cidr_block], var.vpc.secondary_cidr_blocks)
  }

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}"
    },
    local.tags
  )
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.aws_interface_vpc_endpoints

  vpc_id            = var.vpc.id
  service_name      = "com.amazonaws.${var.vpc.region_name}.${each.key}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint.id]

  subnet_ids = [for az in var.availability_zones : aws_subnet.aws_endpoints[az].id]

  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "${var.vpc.name}_${var.name}_${each.key}"
    },
    local.tags
  )
}
