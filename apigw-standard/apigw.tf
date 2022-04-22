terraform {
  experiments = [module_variable_optional_attrs]
}

resource "oci_apigateway_gateway" "apigateway_gateway" {
  compartment_id = var.compartment_ocid
  endpoint_type  = var.gateway_endpoint_public ? "PUBLIC" : "PRIVATE"
  subnet_id      = var.subnet_id
  display_name   = format("%s%s", "apigw-", var.name)
  ca_bundles {
    type = "CERTIFICATE_AUTHORITY"
    certificate_authority_id = var.certificate_authority_id
  }
  certificate_id = oci_certificates_management_certificate.certificate_apigw.id
}

resource "oci_apigateway_deployment" "apigateway_deployment" {
  compartment_id = var.compartment_ocid
  gateway_id = oci_apigateway_gateway.apigateway_gateway.id
  path_prefix = var.deployment_path_prefix
  display_name   = format("%s%s", "apigw-deploy-", var.name)
  specification {
    dynamic "logging_policies" {
      for_each = var.deployment.log_enabled ? [1] : []
      content {
        access_log {
          is_enabled = true
        }
        execution_log {
          is_enabled = true
        }
      }
    }
    request_policies {
      dynamic "mutual_tls" {
        for_each = var.deployment.mutual_tls != null ? [1] : []
        content {
          allowed_sans = concat(var.deployment.mutual_tls.allowed_sans, [oci_certificates_management_certificate.certificate_client.subject[0].common_name])
          is_verified_certificate_required = true
        }
      }
    }
    dynamic "routes" {
      for_each = var.deployment.http_routes != null ? var.deployment.http_routes : []
      content {
        backend {
          url = routes.value.url
          type = "HTTP_BACKEND"
        }
        path = routes.value.path
        methods = routes.value.methods
      }
    }
  }
}