resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true

  tags = merge(
    local.tags,
    var.vpc_tags,
    {
      Name = var.name
    }
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc" {
  for_each = toset(var.secondary_cidr_blocks)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
}
