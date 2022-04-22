resource "oci_dns_zone" "zone" {
    count = var.dns_zone_enabled ? 1 : 0
    compartment_id = var.compartment_ocid
    name = join(".", [var.dns_zone_name, var.dns_zone_parent])
    zone_type = "PRIMARY"
}

resource "oci_dns_rrset" "rrset_main" {
    count = var.dns_zone_enabled ? 1 : 0
    domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
    rtype = "A"
    zone_name_or_id = oci_dns_zone.zone[0].id
    items {
        domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
        rdata = "0.0.0.0"
        rtype = "A"
        ttl = 30
    }
}