module "minimalstack_network" {
  source  = "./modules/network"
  subnets = var.subnets

  providers = {
    openstack = openstack
  }
}