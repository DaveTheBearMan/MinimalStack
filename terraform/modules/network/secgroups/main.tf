# 
data "openstack_identity_project_v3" "minimalstack" {
  name = "VulnerabilityResearch"
}

# Create security group
resource "openstack_networking_secgroup_v2" "security_groups" {
  for_each = var.security_groups

  tenant_id   = data.openstack_identity_project_v3.minimalstack.id
  name        = "Minimal Stack Rule ${each.key}"
  description = each.value.description
}

# This takes all of the security group rules and turns them into a plat list that we can run a for_each over
# The most important step is concat two two tuples that are created from tcp and udp rules, so that we can create
# overlapping rules for ports without worrying about the name.
locals {
  security_group_rule_data = flatten(concat(
    [for security_group_key, security_group_data in var.security_groups : [
      for rule in security_group_data.tcp_rules : {
        security_group_key = security_group_key
        port               = rule
        protocol           = "tcp"
        description        = security_group_data.description
      }
      ]
    ],
    [for security_group_key, security_group_data in var.security_groups : [
      for rule in try(security_group_data.udp_rules, []) : {
        security_group_key = security_group_key
        port               = rule
        protocol           = "udp"
        description        = security_group_data.description
      }
      ]
    ],
  ))
}

# Key [Rule - Port] 
resource "openstack_networking_secgroup_rule_v2" "security_group_rules" {
  for_each = {
    for rule in local.security_group_rule_data :
    "${rule.security_group_key} [${rule.protocol} - ${rule.port}]" => rule
  }

  description       = each.value.description
  protocol          = "tcp"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = each.value.port
  port_range_max    = each.value.port
  security_group_id = openstack_networking_secgroup_v2.security_groups[each.value.security_group_key].id
}