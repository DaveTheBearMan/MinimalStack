# Network Module

This module handles the security groups, subnets, and router for the project in that order.

- [ ] [Secgroups Submodule](#secgroups-submodule)
- [ ] [Router Submodule](#router-submodule)

## Secgroups Submodule
While the secgroups submodule is defined in this networking package, it is controlled by passing in a variable to this module named `security_groups`, with the expected formatting of:

```hcl
# Security groups
variable "security_groups" {
  description = "Security groups to create"
  type = map(object({
    description = optional(string)
    tcp_rules   = optional(set(number), [])
    udp_rules   = optional(set(number), [])
  }))
}
```

Example from project.auto.tfvars:
```hcl
security_groups = {
  "Boundary Controller" = {
    "description" = "Security policy for boundary controller"
    "tcp_rules"   = [9200, 9201]
    "udp_rules"   = []
  }
}
```

## Router Submodule
This module handles the creation of the router for the project. In addition to that, it creates 3 subnets for our project

- [Boundary DMZ](#boundary-dmz)
- [Nomad Subnet](#nomad-subnet)
- [Internal Subnet](#internal-subnet)

#### Boundary DMZ
The boundary DMZ is our externally accessible services for remote access and forwarding. This includes envoy proxy, and boundary controllers. The envoy proxy uses load balancing to point at our two boundary controllers, as well as point to the websites for our internal services. Envoy is one of two public ip addresses for this project (the first being the router).

#### Nomad Subnet
The nomad subnet contains the nomad leader and followers, as well as all of the compute nodes that register to the nomad leader. This subnet also contains two boundary workers, to model the makings of a high availability system. Envoy proxy also points to the nomad leader, with backups to the two followers.

#### Internal Subnet
The internal subnet hosts our consul leader and followers, as well as our primary vault instances. In addition, it has our PostgreSQL database for credential storage / logging for consul. There is a single boundary worker in this subnet, as not as much traffic is expected to be directed into these subnets. 