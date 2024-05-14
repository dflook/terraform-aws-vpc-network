locals {
  az_cidrs = {
    "a" = cidrsubnet(var.cidr_block, 2, 0)
    "b" = cidrsubnet(var.cidr_block, 2, 1)
    "c" = cidrsubnet(var.cidr_block, 2, 2)
    "d" = cidrsubnet(var.cidr_block, 2, 3)
  }
}

resource "aws_subnet" "aws_endpoints" {
  for_each = var.availability_zones

  vpc_id            = var.vpc.id
  cidr_block        = local.az_cidrs[each.key]
  availability_zone = "${var.vpc.region_name}${each.key}"

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${each.key}"
    },
    local.tags
  )
}

resource "aws_route_table" "aws_endpoints" {
  for_each = var.availability_zones

  vpc_id = var.vpc.id

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${each.key}"
    },
    local.tags
  )
}

resource "aws_route_table_association" "aws_endpoints" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.aws_endpoints[each.key].id
  route_table_id = aws_route_table.aws_endpoints[each.key].id
}
