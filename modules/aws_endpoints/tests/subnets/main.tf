variable "vpc" {
  type = object({
    id                    = string
    name                  = string
    region_name           = string
    cidr_block            = string
    secondary_cidr_blocks = list(string)
  })
}

variable "availability_zones" {
  type = list(string)
}

variable "main_cidr_block" {
  type = string
}

module "main_subnets" {
  source             = "../../../subnets"
  name               = "main_cidr_block"
  cidr_block         = var.main_cidr_block
  availability_zones = var.availability_zones
  vpc                = var.vpc
}

output "main_subnets" {
  value = module.main_subnets.subnets
}

variable "secondary_cidr_block" {
  type = string
}

module "secondary_subnets" {
  source             = "../../../subnets"
  name               = "secondary_cidr_block"
  cidr_block         = var.secondary_cidr_block
  availability_zones = var.availability_zones
  vpc                = var.vpc
}

output "secondary_subnets" {
  value = module.secondary_subnets.subnets
}
