output "zone_name" {
  value = oci_dns_zone.zone.name
}
output "vcn_id" {
  value = oci_core_vcn.vcn.id
}
output "subnet_id_lb" {
  value = oci_core_subnet.lb_subnet.id
}
output "subnet_id_node" {
  value = oci_core_subnet.node_subnet.id
}
output "subnet_id_endpoint" {
  value = oci_core_subnet.endpoint_subnet.id
}
output "ingress_reserved_ip" {
  value = oci_core_public_ip.public_ip_ingress.ip_address
}