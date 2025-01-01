module "minimalstack_router" { # Creates router, subnets, and port for router on each subnet
  source          = "./router"
  subnets         = var.subnets
  security_groups = var.security_groups
}