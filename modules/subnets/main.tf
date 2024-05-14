locals {
  az_cidrs = {
    "a" = cidrsubnet(var.cidr_block, 2, 0)
    "b" = cidrsubnet(var.cidr_block, 2, 1)
    "c" = cidrsubnet(var.cidr_block, 2, 2)
    "d" = cidrsubnet(var.cidr_block, 2, 3)
  }
}

resource "aws_subnet" "subnet" {
  for_each = var.availability_zones

  vpc_id            = var.vpc.id
  cidr_block        = local.az_cidrs[each.key]
  availability_zone = "${var.vpc.region_name}${each.key}"

  tags = merge(
    local.tags,
    var.subnet_tags,
    {
      Name = "${var.vpc.name}_${var.name}_${each.key}"
    },
  )
}

resource "aws_route_table" "subnet" {
  for_each = var.availability_zones

  vpc_id = var.vpc.id

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${each.key}"
    },
    local.tags
  )
}

resource "aws_route_table_association" "subnet" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.subnet[each.key].id
}

resource "aws_network_acl" "subnet" {
  vpc_id = var.vpc.id

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}"
    },
    local.tags
  )
}

# These rules allow all traffic in and out of the subnet
# This can be changed by adding lower numbered rules that deny traffic
resource "aws_network_acl_rule" "ingress_allow_all" {
  network_acl_id = aws_network_acl.subnet.id

  rule_number = 32766
  egress      = false
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "egress_allow_all" {
  network_acl_id = aws_network_acl.subnet.id

  rule_number = 32766
  egress      = true
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_association" "subnet" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.subnet[each.key].id
  network_acl_id = aws_network_acl.subnet.id
}
