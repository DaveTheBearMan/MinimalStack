resource "openstack_blockstorage_volume_v3" "instance_volumes" { // create volumes for each host
  count = var.instance.count

  name     = format("%s [%s] - Volume", var.instance.name, count.index)
  size     = var.instance.block_size
  image_id = var.instance.image
}

resource "openstack_networking_port_v2" "network_ports" {
  count      = var.instance.count
  name       = format("%s [%s] - Port", var.instance.name, count.index)
  network_id = var.instance.network_id

  dynamic "fixed_ip" {
    for_each = var.instance.fixed_ip[*]
    content {
      subnet_id  = var.instance.subnet_id
      ip_address = lookup(var.instance, "fixed_ip", null)
    }
  }

  # Look through each security group, and pull ID from list
  security_group_ids = [for security_group in var.instance.security_groups : var.security_group_ids[security_group]]

  # Check and see if there is a particular set of IP addresses allowed to interact with the given port
  # Dynamic block creates the object only if there is something in foreach array
  # We create something in for each array when there is an allowed address pair (1 instance), otherwise, empty list
  dynamic "allowed_address_pairs" {
    for_each = var.instance.allowed_address_pairs[*]
    content { # Content is what each created block from dynamic is assigned 
      ip_address = lookup(each.value, "allowed_address_pairs", null)
    }
  }
}

resource "openstack_compute_instance_v2" "hashistack_instance" {
  count = var.instance.count

  # Name, flavor, and tags
  name      = format("%s [%s] - Instance", var.instance.name, count.index)
  flavor_id = var.instance.flavor_id // assign flavors
  tags      = setunion(var.instance.inherited_tags, var.instance.tags)

  # Security groups and network ports
  security_groups = var.instance.security_groups

  network {
    port = openstack_networking_port_v2.network_ports[count.index].id
  }

  # Storage
  block_device {                                                                              // assign image attributes
    uuid                  = openstack_blockstorage_volume_v3.instance_volumes[count.index].id // the actual image
    boot_index            = 0
    volume_size           = openstack_blockstorage_volume_v3.instance_volumes[count.index].size
    delete_on_termination = true
    source_type           = "volume"
    destination_type      = "volume"
  }

  # Add user data (cloud init)
  user_data    = lookup(var.instance, "user_data", null) != null ? templatefile(var.instance.user_data.file, var.instance.user_data.data) : null
  config_drive = true
}
