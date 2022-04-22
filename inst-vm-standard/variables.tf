# general
variable "compartment_ocid" {
  type = string
}
variable "availability_domain" {
  type = string
}

# naming
variable "name" {
  type = string
}

# networking
variable "subnet_id" {
  type = string
}
variable "public_ip" {
  type = bool
}
variable "private_ip" {
  default = null
  type = string
}

# vm
variable "vm_shape" {
  type = string
}
variable "vm_image_id" {
  type = string
}
variable "vm_memory_gb" {
  type = number
  default = 4
}
variable "vm_ocpu" {
  type = number
  default = 1
}
variable "vm_tags" {
  type = map
}
variable "ssh_authorized_keys_path" {
  type = string
}