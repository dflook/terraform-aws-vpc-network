resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    var.vpc_tags,
    {
      Name = var.name
    }
  )
}
