data "oci_identity_compartment" "compartment" {
  id = var.compartment_ocid
}

resource "oci_identity_dynamic_group" "dynamic_group_autoscale" {
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for autoscale instance"
  matching_rule  = "All {instance.id = '${var.instance_ocid}'}"
  name           = var.dynamic_group_name_autoscale
}

resource "oci_identity_policy" "policy_autoscale" {
  compartment_id = var.tenancy_ocid
  description    = "General policy for autoscale group "
  name           = var.policy_name_autoscale
  statements = [
    "Allow dynamic-group ${var.dynamic_group_name_autoscale} to manage all-resources in tenancy"
  ]
}