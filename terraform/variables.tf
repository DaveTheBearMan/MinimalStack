# Openstack Credentials
variable "openstack_user_name" {
  description = "Openstack openstack_user_name"
  type        = string
  ephemeral   = true # Ephemeral meaning available at run time, these variables are gathered from the environment.
}

variable "openstack_password" {
  description = "Openstack openstack_password"
  type        = string
  ephemeral   = true
}

variable "auth_url" {
  description = "Openstack authentication url"
  type        = string
  ephemeral   = true
}

variable "tenant_name" {
  description = "Openstack project name"
  type        = string
  ephemeral   = true
}