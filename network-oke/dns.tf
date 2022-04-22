resource "oci_dns_zone" "zone" {
    compartment_id = var.compartment_ocid
    name = join(".", [var.dns_zone_name, var.dns_zone_parent])
    zone_type = "PRIMARY"
}

resource "oci_dns_rrset" "rrset_main" {
    domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
    rtype = "A"
    zone_name_or_id = oci_dns_zone.zone.id
    items {
        domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
        rdata = oci_core_public_ip.public_ip_ingress.ip_address
        rtype = "A"
        ttl = 30
    }
}