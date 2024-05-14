output "vpc" {
  value = module.vpc.vpc
}

output "public_subnet" {
  value = module.public_subnet.subnets["a"]
}

output "private_subnets" {
  value = module.private_subnets.subnets
}
