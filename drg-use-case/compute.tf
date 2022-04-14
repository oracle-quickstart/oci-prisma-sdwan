# ------ Create Prisma SDWAN ION VM
resource "oci_core_instance" "prisma-sdwan-vm" {
  count      = 1

  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-${count.index + 1}"
  shape               = var.vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.prisma_sdwan_controller_subnet_id : oci_core_subnet.prisma_sdwan_controller_subnet[0].id
    # display_name           = var.vm_display_name
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    skip_source_dest_check = "true"
    display_name           = "prisma-sdwan-vion-vnic1"
  }

  source_details {
    source_type = "image"
    source_id = var.prisma_sdwan_custom_image_ocid
    boot_volume_size_in_gbs = 100
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

}

resource "oci_core_vnic_attachment" "prisma_sdwan_public_vnic_attachment" {
  count = 1
  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.prisma_sdwan_public_subnet_id : oci_core_subnet.prisma_sdwan_public_subnet[0].id
    assign_public_ip       = "true"
    skip_source_dest_check = "false"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "prisma-sdwan-vion-vnic2"
  }
  instance_id = oci_core_instance.prisma-sdwan-vm[count.index].id
  depends_on = [
    oci_core_instance.prisma-sdwan-vm
  ]
}

resource "oci_core_vnic_attachment" "prisma_sdwan_core_vnic_attachment" {
  count = 1
  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.prisma_sdwan_core_subnet_id : oci_core_subnet.prisma_sdwan_core_subnet[0].id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "prisma-sdwan-vion-vnic3"
  }
  instance_id = oci_core_instance.prisma-sdwan-vm[count.index].id
  depends_on = [
    oci_core_vnic_attachment.prisma_sdwan_public_vnic_attachment
  ]
}

# ------ Create Application VMs
resource "oci_core_instance" "application-vm" {
  count = 1

  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name_application}-${count.index + 1}"
  shape               = var.spoke_vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_spoke_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.application_compute_subnet_id : oci_core_subnet.application_compute_subnet[0].id
    display_name           = var.vm_display_name_application
    assign_public_ip       = false
    nsg_ids                = [oci_core_network_security_group.nsg_application.id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[1].id
    boot_volume_size_in_gbs = "50"
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

}