# general
variable "compartment_ocid" {
  type = string
}
variable "name" {
  type = string
}
variable "cpe_ip_address" {
  type = string
}
variable "cpe_device_shape_id" {
  type = string
}
variable "ipsec_bgp_asn_1" {
  type = string
}
variable "ipsec_bgp_asn_2" {
  type = string
}
variable "ipsec_tunnel_interface_cpe_1" {
  type = string
}
variable "ipsec_tunnel_interface_cpe_2" {
  type = string
}
variable "ipsec_tunnel_interface_oci_1" {
  type = string
}
variable "ipsec_tunnel_interface_oci_2" {
  type = string
}
variable "ipsec_shared_secret_1" {
  type = string
}
variable "ipsec_shared_secret_2" {
  type = string
}