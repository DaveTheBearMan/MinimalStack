# Outputs
output "security_group_instances" {
  description = "Security group instance ids"
  value = merge(
    {
      for security_group_name, security_group_data in var.security_groups :
      security_group_name => openstack_networking_secgroup_v2.security_groups[security_group_name].id
    },
    {
      "default" = "2d53a3f1-2a5f-482d-82f4-9b5e3f6a0bce"
    } 
  )
}