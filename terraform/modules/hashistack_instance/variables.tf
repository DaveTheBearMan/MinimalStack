# Instances..? 
variable "instance" {
  description = "Instance to create"
  type = object({
    # Required parameters
    name = string
    description = string

    # Block instance parameters
    block_size = number
    image = string
  
    # Compute instance parameters
    flavor_id = string
    tags = optional(set(string))

    # Security parameters
    security_groups = optional(set(string))

    # Network paramters
    subnet = optional(string)

    # Userdata
    user_data = optional(object({
      file = string
      data = map(string)
    }))
  })
}