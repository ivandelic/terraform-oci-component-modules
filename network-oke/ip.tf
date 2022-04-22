#resource "oci_core_public_ip_pool" "public_ip_pool_ingress" {
#  compartment_id = var.compartment_ocid
#  display_name = format("%s%s", "ip-pool-", var.name)
#}

resource "oci_core_public_ip" "public_ip_ingress" {
  compartment_id = var.compartment_ocid
  lifetime       = "RESERVED"
  display_name   = format("%s%s", "ip-", var.name)
  private_ip_id  = "ocid1.privateip.oc1.eu-frankfurt-1.abtheljsjib3opbty5tnd7egqmolnlxjt3g3sarvv6gab2nz42tmzqlgs7jq"
  lifecycle {
    ignore_changes = [private_ip_id]
  }
}