data "oci_core_services" "services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "vcn-", var.name)
  dns_label      = replace(var.name, "-", "")
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "ig-", var.name)
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = format("%s%s", "ng-", var.name)
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "sg-", var.name)
  services {
    service_id = data.oci_core_services.services.services.0.id
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_local_peering_gateway" "local_peering_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = format("%s%s", "lpg-", var.name)
}

resource "oci_core_subnet" "lb_subnet" {
  cidr_block                 = var.subnet_lb
  compartment_id             = var.compartment_ocid
  display_name               = format("%s%s", "sn-lb-", var.name)
  dns_label                  = "lb"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_default_route_table.route_table_default.id
  security_list_ids          = [oci_core_default_security_list.security_list_lb2.id]
  vcn_id                     = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "node_subnet" {
  cidr_block                 = var.subnet_node
  compartment_id             = var.compartment_ocid
  display_name               = format("%s%s", "sn-node-", var.name)
  dns_label                  = "node"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.route_table_node.id
  security_list_ids          = [oci_core_security_list.security_list_node.id]
  vcn_id                     = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "endpoint_subnet" {
  cidr_block                 = var.subnet_endpoint
  compartment_id             = var.compartment_ocid
  display_name               = format("%s%s", "sn-endpoint-", var.name)
  dns_label                  = "endpoint"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_default_route_table.route_table_default.id
  security_list_ids          = [oci_core_security_list.security_list_endpoint.id]
  vcn_id                     = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "route_table_node" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "rt-node-", var.name)
  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
  route_rules {
    description       = "traffic to OCI services"
    destination       = "all-fra-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
  route_rules {
    description       = "traffic to db"
    destination       = "10.1.0.0/16"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.local_peering_gateway.id
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "route_table_default" {
  display_name = format("%s%s", "rt-default-", var.name)
  route_rules {
    description       = "traffic to/from internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
}

resource "oci_core_default_security_list" "security_list_lb2" {
  compartment_id             = var.compartment_ocid
  display_name               = format("%s%s", "sl-lb-", var.name)
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
  ingress_security_rules {
    description = "Expose port 80"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 443
      min = 443
    }
  }
  egress_security_rules {
    description      = "Outbound traffic from load balancers to nodes"
    destination_type = "CIDR_BLOCK"
    destination      = var.subnet_node
    protocol         = "6"
    stateless        = false
    tcp_options {
      min = 30000
      max = 32767
    }
  }
}

resource "oci_core_security_list" "security_list_node" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "sl-node-", var.name)
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination      = var.subnet_node
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Access to Kubernetes API Endpoint"
    destination      = var.subnet_endpoint
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
  egress_security_rules {
    description      = "Kubernetes worker to control plane communication"
    destination      = var.subnet_endpoint
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
    tcp_options {
      min = 12250
      max = 12250
    }
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.subnet_endpoint
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
  }
  egress_security_rules {
    description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    destination      = "all-fra-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
    tcp_options {
      min = 443
      max = 443
    }
  }
  egress_security_rules {
    description      = "ICMP Access from Kubernetes Control Plane"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
  }
  egress_security_rules {
    description      = "Worker Nodes access to Internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
    protocol    = "all"
    source      = var.subnet_node
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    source    = var.subnet_endpoint
    stateless = "false"
  }
  ingress_security_rules {
    description = "TCP access from Kubernetes Control Plane"
    protocol    = "6"
    source      = var.subnet_endpoint
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Inbound k8s traffic from load balancers"
    protocol    = "6"
    source      = var.subnet_lb
    stateless   = "false"
    tcp_options {
      min = 30000
      max = 32767
    }
  }
  ingress_security_rules {
    description = "Inbound SSH traffic to worker nodes"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
    tcp_options {
      min = 22
      max = 22
    }
  }
  vcn_id = oci_core_vcn.vcn.id
  lifecycle {
    ignore_changes = [ingress_security_rules]
  }
}

resource "oci_core_security_list" "security_list_endpoint" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s%s", "sl-endpoint-", var.name)
  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = "all-fra-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
    tcp_options {
      min = 443
      max = 443
    }
  }
  egress_security_rules {
    description      = "All traffic to worker nodes"
    destination      = var.subnet_node
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.subnet_node
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
  }
  ingress_security_rules {
    description = "External access to Kubernetes API endpoint"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    protocol    = "6"
    source      = var.subnet_node
    stateless   = "false"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to control plane communication"
    protocol    = "6"
    source      = var.subnet_node
    stateless   = "false"
    tcp_options {
      min = 12250
      max = 12250
    }
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    source    = var.subnet_node
    stateless = "false"
  }
  vcn_id = oci_core_vcn.vcn.id
}


