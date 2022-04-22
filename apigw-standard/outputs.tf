output "gateway_id" {
  value = oci_apigateway_gateway.apigateway_gateway.id
}

output "gateway_ip_addresses" {
  value = oci_apigateway_gateway.apigateway_gateway.ip_addresses
}