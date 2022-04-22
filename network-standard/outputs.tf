output "vcn_id" {
  value = oci_core_vcn.vcn.id
}
output "subnet_id_public" {
  value = oci_core_subnet.subnet_public.id
}
output "subnet_id_private" {
  value = oci_core_subnet.subnet_private.id
}