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