variable "test_name" {
  description = "The name of the test"
  type        = string
}

variable "vpc" {
  description = "The VPC to test connectivity in"
  type = object({
    id = string
  })
}

variable "subnet" {
  description = "The VPC to test connectivity in"
  type = object({
    id = string
  })
}

variable "url" {
  description = "The URL to test connectivity to"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the test instance"
  type        = bool
}