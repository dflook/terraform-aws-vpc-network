resource "aws_eip" "nat" {
  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${var.public_subnet.availability_zone}"
    },
    local.tags
  )
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet.id

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${var.public_subnet.availability_zone}"
    },
    local.tags
  )
}

resource "aws_route" "nat" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}