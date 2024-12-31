# # Openstack Credentials
# variable "openstack_user_name" {
#   description = "Openstack openstack_user_name"
#   type        = string
# }

# variable "openstack_password" {
#   description = "Openstack password"
#   type        = string
# }

# variable "auth_url" {
#   description = "Openstack authentication url"
#   type        = string
# }

# variable "tenant_name" {
#   description = "Openstack project name"
#   type        = string
# }

# Network Variables
variable "subnets" { # DHCP is turned off, unless a particular allocation pool is defined. 
  description = "Subnets to create for the project"
  type = map(object({
    cidr = string

    allocation_pool = optional(map(string)) # optional, sets an address range for dhcp.
    dns_nameservers = optional(set(string))
  }))
}

variable "security_groups" {
  description = "All of the security groups for the project"
  type        = map(string)
  default = {
    "default" = "2d53a3f1-2a5f-482d-82f4-9b5e3f6a0bce"
  }
}