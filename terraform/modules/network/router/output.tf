output "network" {
  description = "Network for the infrastructure"
  value       = openstack_networking_network_v2.core_router_network.id
}

output "subnets" {
  description = "Subnets on the network"
  value = {
    for subnet_name, _ in local.subnet_decoded :
    subnet_name => openstack_networking_subnet_v2.core_router_subnets[subnet_name].id
  }
}