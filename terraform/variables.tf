# Openstack credentials 
variable "username" {
  description = "Openstack Username"
  type        = string
}

variable "password" {
  description = "Openstack Password"
  type        = string
}

variable "auth_url" {
  description = "Openstack authentication url"
  type        = string
}

variable "tenant_name" {
  description = "Openstack project name"
  type        = string
}