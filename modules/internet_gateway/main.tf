resource "aws_internet_gateway" "vpc" {
  vpc_id = var.vpc.id

  tags = merge(
    local.tags,
    {
      Name = var.vpc.name
    }
  )
}

resource "aws_route" "igw" {
  for_each = var.public_subnets

  route_table_id         = each.value.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc.id
}
