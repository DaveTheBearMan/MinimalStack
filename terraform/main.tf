module "minimalstack_network" {
  source = "./modules/network"

  # Subnets
  subnets = "${path.root}/structure/subnets.yaml"

  # Security groups
  security_groups = "${path.root}/structure/security_groups.yaml"
}

data "openstack_compute_flavor_v2" "flavor_l2_small" {
  name = "l2-small"
}


module "minimalstack_instance" {
  source             = "./modules/hashistack_instance"
  security_group_ids = module.minimalstack_network.security_group_instances

  instance = {
    # Basic
    name        = "Test"
    description = "Test instance"
    count       = 2

    # Volume
    block_size = 25
    image      = "-"

    # Compute
    flavor_id = "-"

    # Sec Groups
    inherited_tags  = ["Development"]
    tags            = ["Test Instance"]
    security_groups = ["SSH"]

    # Networks
    network_id = "-"
    subnet_id  = "-"
  }
}