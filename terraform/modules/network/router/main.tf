locals {
  subnet_decoded = yamldecode(file(var.subnets))
}

# Core router and network
resource "openstack_networking_router_v2" "core_router" {
  name                = var.core_router
  admin_state_up      = "true"
  external_network_id = var.external_network_id
}

resource "openstack_networking_network_v2" "core_router_network" {
  name           = var.network
  admin_state_up = "true"
}

# Subnets
resource "openstack_networking_subnet_v2" "core_router_subnets" {
  # Grab the subnet from the list of all subnets, and attach them to our network
  for_each = local.subnet_decoded

  name       = each.key
  network_id = openstack_networking_network_v2.core_router_network.id

  # IP addresses
  gateway_ip = cidrhost(each.value.cidr, 254) # https://developer.hashicorp.com/terraform/language/functions/cidrhost
  cidr       = each.value.cidr
  ip_version = 4

  # DHCP
  enable_dhcp = lookup(each.value, "allocation_pool", null) != null ? true : false
  dynamic "allocation_pool" {
    for_each = contains(keys(each.value), "allocation_pool") ? [each.value.allocation_pool] : [] # Check if there is a key for allocation pool.
    content {
      start = allocation_pool.value.start
      end   = allocation_pool.value.end
    }
  }

  # Name servers (Defaults to cloudflare DNS servers)
  dns_nameservers = lookup(each.value, "dns_nameservers", ["1.1.1.1", "1.0.0.1"])
}

resource "openstack_networking_router_interface_v2" "core_router_interfaces" {
  for_each = local.subnet_decoded
  
  router_id = openstack_networking_router_v2.core_router.id
  subnet_id = openstack_networking_subnet_v2.core_router_subnets[each.key].id
}
