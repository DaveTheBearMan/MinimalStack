# Network Variables
variable "subnets" { # DHCP is turned off, unless a particular allocation pool is defined. 
  description = "Subnets to create for the project (path to yaml file)"
  type        = string
}

variable "security_group_instances" {
  description = "All of the security groups for the project"
  type        = map(string)
  default = {
    "default" = "2d53a3f1-2a5f-482d-82f4-9b5e3f6a0bce"
  }
}

# Security groups
variable "security_groups" {
  description = "Security groups to create (path to yaml file)"
  type        = string
}