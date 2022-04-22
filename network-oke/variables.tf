# general
variable "compartment_ocid" {
  type = string
}

# naming
variable "name" {
  type = string
}

# vcn
variable "vcn_cidr" {
  type = string
}
variable "subnet_endpoint" {
  type = string
}
variable "subnet_lb" {
  type = string
}
variable "subnet_node" {
  type = string
}

# dns zone and records
variable "dns_zone_name" {
  type = string
}
variable "dns_zone_parent" {
  type = string
}