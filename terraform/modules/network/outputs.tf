output "security_group_instances" {
  value = module.minimalstack_security_groups.security_group_instances
}

output "subnets" {
  description = "Subnets on the network"
  value       = module.minimalstack_router.subnets
}

output "network" {
  description = "Network for the infrastructure"
  value       = module.minimalstack_router.network
}