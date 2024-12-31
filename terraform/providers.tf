terraform {
  required_version = ">= 1.10.3"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.0.0"
    }
  }
}

provider "openstack" {
  user_name   = var.openstack_user_name
  password    = var.openstack_password
  tenant_name = var.tenant_name
  auth_url    = var.auth_url
}