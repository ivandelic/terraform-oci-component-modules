resource "oci_core_cpe" "cpe_star" {
    compartment_id = var.compartment_ocid
    ip_address = var.cpe_ip_address
    cpe_device_shape_id = var.cpe_device_shape_id
    display_name = format("%s%s", "cpe-", var.name)
}

resource "oci_core_drg" "drg_star" {
    compartment_id = var.compartment_ocid
    display_name = format("%s%s", "drg-", var.name)
}

resource "oci_core_ipsec" "ipsec_star" {
    compartment_id = var.compartment_ocid
    cpe_id = oci_core_cpe.cpe_star.id
    drg_id = oci_core_drg.drg_star.id
    static_routes = ["0.0.0.0/0"]
    display_name = format("%s%s", "ipsec-", var.name)
}

data "oci_core_ipsec_connection_tunnels" "ipsec_connection_tunnels_star" {
    ipsec_id = oci_core_ipsec.ipsec_star.id
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec_connection_tunnel_management_star_1" {
    ipsec_id = oci_core_ipsec.ipsec_star.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.ipsec_connection_tunnels_star.ip_sec_connection_tunnels[0].id
    routing = "BGP"
    bgp_session_info {
        customer_bgp_asn = var.ipsec_bgp_asn_1
        customer_interface_ip = var.ipsec_tunnel_interface_cpe_1
        oracle_interface_ip = var.ipsec_tunnel_interface_oci_1
    }
    display_name = format("%s%s", "tunnel-1-", var.name)
    shared_secret = var.ipsec_shared_secret_1
    ike_version = "V2"
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec_connection_tunnel_management_star_2" {
    ipsec_id = oci_core_ipsec.ipsec_star.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.ipsec_connection_tunnels_star.ip_sec_connection_tunnels[1].id
    routing = "BGP"
    bgp_session_info {
        customer_bgp_asn = var.ipsec_bgp_asn_2
        customer_interface_ip = var.ipsec_tunnel_interface_cpe_2
        oracle_interface_ip = var.ipsec_tunnel_interface_oci_2
    }
    display_name = format("%s%s", "tunnel-2-", var.name)
    shared_secret = var.ipsec_shared_secret_2
    ike_version = "V2"
}