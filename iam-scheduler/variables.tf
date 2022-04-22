# general
variable "tenancy_ocid" {
  type = string
}
variable "compartment_ocid" {
  type = string
}

# main
variable "instance_ocid" {
  type = string
}
variable "dynamic_group_name_autoscale" {
  type = string
}
variable "policy_name_autoscale" {
  type = string
}