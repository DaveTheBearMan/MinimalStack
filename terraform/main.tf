module "minimalstack_network" {
  source          = "./modules/network"
  subnets         = var.subnets
  security_groups = var.security_groups
}