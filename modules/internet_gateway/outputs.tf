output "internet_gateway_id" {
  description = <<-EOT
    The ID of the internet gateway

    Example: `"igw-12345678"`
  EOT

  value = aws_internet_gateway.vpc.id

  precondition {
    condition     = startswith(aws_internet_gateway.vpc.id, "igw-")
    error_message = "The Internet Gateway ID is not in the expected format."
  }
}