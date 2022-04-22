# general
variable "compartment_ocid" {
  type = string
}
variable "availability_domain" {
  type = string
}

# naming
variable "name" {
  type = string
}

# networking
variable "subnet_id" {
  type = string
}
variable "gateway_endpoint_public" {
  type = bool
}

variable "deployment_path_prefix" {
  type = string
}

variable "certificate_authority_id" {
  type = string
}

variable "deployment" {
  default = null
  type = object({
    log_enabled = optional(bool)
    cors = optional(object({
      allowed_origins = list(string)
      allowed_headers = optional(list(string))
      allowed_methods = optional(list(string))
    }))
    mutual_tls = optional(object({
      allowed_sans = optional(list(string))
    }))
    http_routes = list(object({
      url = string
      path = string
      methods = list(string)
    }))
  })
}

variable "dns_api_zone_parent" {
  type = string
}