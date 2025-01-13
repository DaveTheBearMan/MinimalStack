# Security group ids from the network module 
variable "security_group_ids" {
  description = "Security group id output"
  type        = map(string)
}

# Instance to create 
variable "instance" {
  description = "Instance to create"
  type = object({
    # Required parameters
    name        = string
    description = string
    count       = number

    # Block instance parameters
    block_size = number
    image      = string

    # Compute instance parameters
    flavor_id      = string
    inherited_tags = set(string)
    tags           = set(string)

    # Security parameters
    security_groups = optional(set(string))

    # Network paramters
    network_id = string
    subnet_id  = string
    fixed_ip   = optional(string)

    # Userdata
    user_data = optional(object({
      file = string
      data = map(string)
    }))

    # Address pairs
    allowed_address_pairs = optional(object({
      ip_address  = string
      mac_address = optional(string)
    }))

    public_ip = optional(string)
  })
}