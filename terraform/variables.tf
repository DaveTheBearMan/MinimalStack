# Minimalstack Network Variables
variable "subnets" { # DHCP is turned off, unless a particular allocation pool is defined. 
  description = "Subnets to create for the project"
  type = map(object({
    cidr = string

    allocation_pool = optional(map(string)) # optional, sets an address range for dhcp.
    dns_nameservers = optional(set(string))
  }))
}