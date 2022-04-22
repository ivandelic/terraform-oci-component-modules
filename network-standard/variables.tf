# general
variable "compartment_ocid" {
  type = string
}

# naming
variable "name" {
  type = string
}

# vcn
variable "vcn_cidr" {
  type = string
}
variable "subnet_private" {
  type = string
}
variable "subnet_public" {
  type = string
}

# dns zone and records
variable "dns_zone_name" {
  type = string
}
variable "dns_zone_parent" {
  type = string
}

variable "dns_zone_enabled" {
  type = bool
}

variable "rt_rules_public" {
  default = null
  type    = list(object({
    description         = string
    destination         = string
    destination_type    = string
    network_entity_type = string
    network_entity_id   = optional(string)
  }))
}

variable "rt_rules_private" {
  default = null
  type    = list(object({
    description         = string
    destination         = string
    destination_type    = string
    network_entity_type = string
    network_entity_id   = optional(string)
  }))
}

variable "sl_rules_private" {
  default = null
  type    = object({
    egress_security_rules = optional(list(object({
      destination      = string
      protocol         = string
      description      = optional(string)
      destination_type = optional(string)
      stateless        = optional(bool)
      tcp_options      = optional(object({
        min = number
        max = number
      }))
      udp_options = optional(object({
        min = number
        max = number
      }))
      icmp_options = optional(object({
        type = number
        code = optional(number)
      }))
    })))
    ingress_security_rules = optional(list(object({
      source      = string
      protocol    = string
      description = optional(string)
      source_type = optional(string)
      stateless   = optional(bool)
      tcp_options = optional(object({
        min = number
        max = number
      }))
      udp_options = optional(object({
        min = number
        max = number
      }))
      icmp_options = optional(object({
        type = number
        code = optional(number)
      }))
    })))
  })
}

variable "sl_rules_public" {
  default = null
  type    = object({
    egress_security_rules = optional(list(object({
      destination      = string
      protocol         = string
      description      = optional(string)
      destination_type = optional(string)
      stateless        = optional(bool)
      tcp_options      = optional(object({
        min = number
        max = number
      }))
      udp_options = optional(object({
        min = number
        max = number
      }))
      icmp_options = optional(object({
        type = number
        code = optional(number)
      }))
    })))
    ingress_security_rules = optional(list(object({
      source      = string
      protocol    = string
      description = optional(string)
      source_type = optional(string)
      stateless   = optional(bool)
      tcp_options = optional(object({
        min = number
        max = number
      }))
      udp_options = optional(object({
        min = number
        max = number
      }))
      icmp_options = optional(object({
        type = number
        code = optional(number)
      }))
    })))
  })
}