output "nat_gateway_id" {
  description = <<-EOT
    The ID of the NAT Gateway.

    Type: `string`

    Example: `"nat-0a1234567890abcdef"`
  EOT

  value = aws_nat_gateway.ngw.id

  precondition {
    condition     = startswith(aws_nat_gateway.ngw.id, "nat-")
    error_message = "The NAT Gateway ID is not in the expected format."
  }
}

output "nat_gateway_egress_ip" {
  description = <<-EOT
    The public IP address of the NAT Gateway.

    This is the IP address that is used for egress traffic from the private subnets.

    Type: `string`

    Example: `"192.0.2.0"`
  EOT

  value = aws_eip.nat.public_ip
}
