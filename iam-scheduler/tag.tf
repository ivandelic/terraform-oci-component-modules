resource "oci_identity_tag_namespace" "tag_namespace_autoscale" {
  compartment_id = var.compartment_ocid
  description = "Namespace for schedule tags"
  name = "Schedule"
}

resource "oci_identity_tag" "tag_AnyDay" {
  description = "AnyDay"
  name = "AnyDay"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_WeekDay" {
  description = "WeekDay"
  name = "WeekDay"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Weekend" {
  description = "Weekend"
  name = "Weekend"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Monday" {
  description = "Monday"
  name = "Monday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Tuesday" {
  description = "Tuesday"
  name = "Tuesday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Wednesday" {
  description = "Wednesday"
  name = "Wednesday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Thursday" {
  description = "Thursday"
  name = "Thursday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Friday" {
  description = "Friday"
  name = "Friday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Saturday" {
  description = "Saturday"
  name = "Saturday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}

resource "oci_identity_tag" "tag_Sunday" {
  description = "Sunday"
  name = "Sunday"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace_autoscale.id
}