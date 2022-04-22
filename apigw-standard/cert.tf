resource "oci_certificates_management_certificate" "certificate_apigw" {
  certificate_config {
    issuer_certificate_authority_id = var.certificate_authority_id
    config_type = "ISSUED_BY_INTERNAL_CA"
    certificate_profile_type = "TLS_SERVER"
    key_algorithm = "RSA2048"
    signature_algorithm = "SHA256_WITH_RSA"
    subject {
      common_name = join(".", [var.name, var.dns_api_zone_parent])
    }
    subject_alternative_names {
      type = "DNS"
      value = join(".", [var.name, var.dns_api_zone_parent])
    }
  }
  compartment_id = var.compartment_ocid
  name = join("-", ["cert", var.name])
  certificate_rules {
    advance_renewal_period = "P30D"
    renewal_interval = "P365D"
    rule_type = "CERTIFICATE_RENEWAL_RULE"
  }
}

resource "oci_certificates_management_certificate" "certificate_client" {
  certificate_config {
    issuer_certificate_authority_id = var.certificate_authority_id
    config_type = "ISSUED_BY_INTERNAL_CA"
    certificate_profile_type = "TLS_CLIENT"
    key_algorithm = "RSA2048"
    signature_algorithm = "SHA256_WITH_RSA"
    subject {
      common_name = join(".", [join("-", ["client", var.name]), var.dns_api_zone_parent])
    }
  }
  compartment_id = var.compartment_ocid
  name = join("-", ["cert", "client", var.name])
  certificate_rules {
    advance_renewal_period = "P30D"
    renewal_interval = "P365D"
    rule_type = "CERTIFICATE_RENEWAL_RULE"
  }
}