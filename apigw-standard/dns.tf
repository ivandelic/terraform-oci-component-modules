resource "oci_dns_rrset" "rrset_apigw" {
    domain = join(".", [var.name, var.dns_api_zone_parent])
    rtype = "A"
    zone_name_or_id = var.dns_api_zone_parent
    items {
        domain = join(".", [var.name, var.dns_api_zone_parent])
        rdata = oci_apigateway_gateway.apigateway_gateway.ip_addresses[0].ip_address
        rtype = "A"
        ttl = 30
    }
}