module "minimalstack_security_groups" {
  source          = "./secgroups"
  security_groups = var.security_groups
}

module "minimalstack_router" { # Creates router, subnets, and port for router on each subnet
  source                   = "./router"
  subnets                  = var.subnets
  security_group_instances = var.security_group_instances
}

