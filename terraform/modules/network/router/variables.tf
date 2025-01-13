variable "core_router" {
  description = "Name of the core router to create"
  type        = string
  default     = "Minimal Stack Core Router"
}

variable "network" {
  description = "Name of the network for the project"
  type        = string
  default     = "Minimal Stack Core Network"
}

variable "external_network_id" {
  description = "External network ID"
  type        = string
  default     = "418d945b-4e96-4be5-b81e-9cb857f2f64b" # RIT WAN
}

# Network Variables
variable "subnets" { # DHCP is turned off, unless a particular allocation pool is defined. 
  description = "Subnets to create for the project (path to yaml file)"
  type        = string
}

variable "security_group_instances" {
  description = "All of the security groups for the project"
  type        = map(string)
}