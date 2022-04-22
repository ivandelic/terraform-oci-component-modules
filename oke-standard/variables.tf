# general
variable "compartment_ocid" {
  type = string
}

# naming
variable "name" {
  type = string
}

# k8s
variable "k8s_version" {
  type = string
}
variable "k8s_is_public_endpoint" {
  type = bool
}

# networking
variable "vcn_id" {
  type = string
}
variable "subnet_id_lb" {
  type = string
}
variable "subnet_id_node" {
  type = string
}
variable "subnet_id_endpoint" {
  type = string
}

# pool and vms
variable "pool_name" {
  type = string
}
variable "pool_total_vm" {
  type = string
}
variable "vm_shape" {
  type = string
}
variable "vm_memory" {
  type = number
}
variable "vm_ocpu" {
  type = number
}
variable "vm_image_id" {
  type = string
}
