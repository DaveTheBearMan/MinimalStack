module "minimalstack_network" {
  source          = "./modules/network"

  # Subnets
  subnets         = "${path.root}/structure/subnets.yaml"

  # Security groups
  security_groups = "${path.root}/structure/security_groups.yaml"
}