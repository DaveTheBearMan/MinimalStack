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

data "openstack_images_image_v2" "image_ubuntu_24" {
  name = "UbuntuNoble2404"
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
    image      = data.openstack_images_image_v2.image_ubuntu_24.id

    # Compute
    flavor_id = data.openstack_compute_flavor_v2.flavor_l2_small.id

    # Sec Groups
    inherited_tags  = ["Development"]
    tags            = ["Test Instance"]
    security_groups = ["SSH"]

    # Networks
    network_id = module.minimalstack_network.network
    subnet_id  = module.minimalstack_network.subnets["Boundary DMZ"]
    public_ip  = "RIT WAN"

    # user data?
    user_data = {
      file = "${path.root}/templates/cloud-init.tftpl"
      data = {
        username = "DTBM"
        password = 
        ssh_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqxL0S4KqxhrK25r+R08yFneearJu5xjzb8ek6Ac0tR dtbm@development"
      }
    }
  }
}