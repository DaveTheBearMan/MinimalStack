# Openstack Credentials
variable "openstack_user_name" {
  description = "Openstack openstack_user_name"
  type        = string
  ephemeral   = true # Ephemeral meaning available at run time, these variables are gathered from the environment.
}

variable "openstack_password" {
  description = "Openstack openstack_password"
  type        = string
  ephemeral   = true
}

variable "auth_url" {
  description = "Openstack authentication url"
  type        = string
  ephemeral   = true
}

variable "tenant_name" {
  description = "Openstack project name"
  type        = string
  ephemeral   = true
}


# Minimalstack Network Variables
variable "subnets" { # DHCP is turned off, unless a particular allocation pool is defined. 
  description = "Subnets to create for the project"
  type = map(object({
    cidr = string

    allocation_pool = optional(map(string)) # optional, sets an address range for dhcp.
    dns_nameservers = optional(set(string))
  }))
}

# Security groups
variable "security_groups" {
  description = "Security groups to create"
  type = map(object({
    description = optional(string)
    tcp_rules   = optional(set(number), [])
    udp_rules   = optional(set(number), [])
  }))
}