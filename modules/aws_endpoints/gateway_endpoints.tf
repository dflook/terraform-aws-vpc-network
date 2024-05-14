locals {
  gateway_vpc_endpoints = toset(["s3", "dynamodb"])
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = local.gateway_vpc_endpoints

  vpc_id       = var.vpc.id
  service_name = "com.amazonaws.${var.vpc.region_name}.${each.key}"

  tags = merge(
    {
      Name = "${var.vpc.name}_${var.name}_${each.key}"
    },
    local.tags
  )
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  for_each = { for subnet in var.routed_subnets : subnet.name => subnet.route_table_id }

  route_table_id  = each.value
  vpc_endpoint_id = aws_vpc_endpoint.gateway["dynamodb"].id
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  for_each = { for subnet in var.routed_subnets : subnet.name => subnet.route_table_id }

  route_table_id  = each.value
  vpc_endpoint_id = aws_vpc_endpoint.gateway["s3"].id
}
