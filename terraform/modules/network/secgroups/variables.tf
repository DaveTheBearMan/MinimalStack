# Security groups
variable "security_groups" {
  description = "Security groups to create"
  type = map(object({
    description = optional(string)
    tcp_rules   = optional(set(number), [])
    udp_rules   = optional(set(number), [])
  }))
}