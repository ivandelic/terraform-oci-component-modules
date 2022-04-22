data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

resource "oci_containerengine_cluster" "oke" {
  compartment_id = var.compartment_ocid
  endpoint_config {
    is_public_ip_enabled = var.k8s_is_public_endpoint
    subnet_id            = var.subnet_id_endpoint
  }
  kubernetes_version = var.k8s_version
  name               = format("%s%s", "oke-", var.name)
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = true
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    service_lb_subnet_ids = [var.subnet_id_lb]
  }
  vcn_id = var.vcn_id
}

resource "oci_containerengine_node_pool" "workers" {
  cluster_id     = oci_containerengine_cluster.oke.id
  compartment_id = var.compartment_ocid
  initial_node_labels {
    key   = "name"
    value = format("%s%s", "oke-", var.name)
  }
  kubernetes_version = var.k8s_version
  name               = var.pool_name
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.subnet_id_node
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id           = var.subnet_id_node
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id           = var.subnet_id_node
    }
    size = var.pool_total_vm
    #defined_tags = {"Schedule.AnyDay" = "0,0,0,0,0,0,0,*,*,*,*,*,*,*,*,*,*,*,*,0,0,0,0,0"}
  }
  node_shape = var.vm_shape
  node_shape_config {
    memory_in_gbs = var.vm_memory
    ocpus         = var.vm_ocpu
  }
  node_source_details {
    image_id    = var.vm_image_id
    source_type = "IMAGE"
  }
}
