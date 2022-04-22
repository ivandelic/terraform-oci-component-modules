resource "oci_core_instance" "instance_nais_app" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  shape               = var.vm_shape
  display_name        = format("%s%s", "inst-", var.name)

  create_vnic_details {
    display_name     = format("%s%s", "vnic-", var.name)
    subnet_id        = var.subnet_id
    assign_public_ip = var.public_ip
    private_ip       = var.private_ip
    hostname_label   = format("%s%s", "inst-", var.name)
  }
  source_details {
    source_id   = var.vm_image_id
    source_type = "image"
  }
  shape_config {
    memory_in_gbs = var.vm_memory_gb
    ocpus         = var.vm_ocpu
  }
  defined_tags = var.vm_tags
  metadata     = {
    ssh_authorized_keys = file(var.ssh_authorized_keys_path)
  }
  preserve_boot_volume = false
  lifecycle {
    ignore_changes = [defined_tags]
  }
}
