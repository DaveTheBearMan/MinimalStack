# 
locals {
  security_group_decoded = yamldecode(file(var.security_groups))
}
data "openstack_identity_project_v3" "minimalstack" {
  name = "VulnerabilityResearch"
}

# Create security group
resource "openstack_networking_secgroup_v2" "security_groups" {
  for_each = local.security_group_decoded

  tenant_id   = data.openstack_identity_project_v3.minimalstack.id
  name        = "Minimal Stack Rule ${each.key}"
  description = each.value.description
}

# This takes all of the security group rules and turns them into a plat list that we can run a for_each over
locals {
  security_group_rule_data = flatten([
    for security_group_key, security_group_data in local.security_group_decoded : [
      for rule in security_group_data.rules : {
        security_group_key = security_group_key
        port               = rule.port
        protocol           = contains(keys(rule), "protocol") ? rule.protocol : "tcp" # Optional parameters
        direction          = contains(keys(rule), "direction") ? rule.direction : "ingress"
        ethertype          = contains(keys(rule), "ethertype") ? rule.ethertype : "IPv4"
        description        = security_group_data.description
      }
    ]
  ])
}

# Key [Rule - Port] 
resource "openstack_networking_secgroup_rule_v2" "security_group_rules" {
  for_each = {
    for rule in local.security_group_rule_data :
    "${rule.security_group_key} [${rule.protocol} - ${rule.port}]" => rule
  }

  description       = each.value.description
  protocol          = each.value.protocol
  direction         = each.value.direction
  ethertype         = each.value.ethertype
  port_range_min    = each.value.port
  port_range_max    = each.value.port
  security_group_id = openstack_networking_secgroup_v2.security_groups[each.value.security_group_key].id
}