# ------ Get Network Compartment Name for Policies
data "oci_identity_compartment" "network_compartment" {
  id = var.network_compartment_ocid
}


# ------ Get list of availability domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# ------ Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id = var.compute_compartment_ocid
  # operating_system         = var.instance_os
  # operating_system_version = var.linux_os_version
  shape = var.spoke_vm_compute_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# ------ Get the Oracle Tenancy ID
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}


# ------ Get the Tenancy ID and AD Number
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

# ------ Get the Tenancy ID and ADs
data "oci_identity_availability_domains" "ads" {
  #Required
  compartment_id = var.tenancy_ocid
}

# ------ Get the Faulte Domain within AD 
data "oci_identity_fault_domains" "fds" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = var.compute_compartment_ocid

  depends_on = [
    data.oci_identity_availability_domain.ad,
  ]
}

# ------ Get the attachement based on Public Subnet
data "oci_core_vnic_attachments" "untrust_attachments" {
  compartment_id = var.network_compartment_ocid
  instance_id    = oci_core_instance.prisma-sdwan-vm.0.id

  filter {
    name   = "subnet_id"
    values = [local.use_existing_network ? var.prisma_sdwan_public_subnet_id : oci_core_subnet.prisma_sdwan_public_subnet[0].id]
  }

  depends_on = [
    oci_core_vnic_attachment.prisma_sdwan_public_vnic_attachment
  ]
}

# ------ Get the attachement based on Private Subnet
data "oci_core_vnic_attachments" "trust_attachments" {
  compartment_id = var.network_compartment_ocid
  instance_id    = oci_core_instance.prisma-sdwan-vm.0.id

  filter {
    name   = "subnet_id"
    values = [local.use_existing_network ? var.prisma_sdwan_core_subnet_id : oci_core_subnet.prisma_sdwan_core_subnet[0].id]
  }

  depends_on = [
    oci_core_vnic_attachment.prisma_sdwan_core_vnic_attachment,
  ]
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_prisma_sdwan_controller" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.prisma_sdwan_vcn_id : oci_core_vcn.prisma_sdwan.0.id
  filter {
    name   = "display_name"
    values = ["prisma-sdwan-controller-sl"]
  }
  depends_on = [
    oci_core_security_list.allow_prisma_sdwan_controller_security,
  ]
}


# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_prisma_sdwan_core" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.prisma_sdwan_vcn_id : oci_core_vcn.prisma_sdwan.0.id
  filter {
    name   = "display_name"
    values = ["prisma-sdwan-core-sl"]
  }
  depends_on = [
    oci_core_security_list.allow_prisma_sdwan_core_security,
  ]
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_prisma_sdwan_public" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.prisma_sdwan_vcn_id : oci_core_vcn.prisma_sdwan.0.id
  filter {
    name   = "display_name"
    values = ["prisma-sdwan-public-sl"]
  }
  depends_on = [
    oci_core_security_list.allow_prisma_sdwan_public_security,
  ]
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_application" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.application_vcn_id : oci_core_vcn.application.0.id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security_application,
  ]
}

# ------ Get the Private IPs using Untrust Subnet
data "oci_core_private_ips" "prisma_sdwan_public_subnet_public_ips" {
  subnet_id = oci_core_subnet.prisma_sdwan_public_subnet.0.id

  depends_on = [
    oci_core_vnic_attachment.prisma_sdwan_public_vnic_attachment,
  ]
}

# ------ Get the Private IPs using Trust Subnet
data "oci_core_private_ips" "prisma_sdwan_core_subnet_private_ips" {
  subnet_id = oci_core_subnet.prisma_sdwan_core_subnet[0].id
  filter {
    name   = "display_name"
    values = ["prisma-sdwan-vion-vnic3"]
  }
  depends_on = [
    oci_core_vnic_attachment.prisma_sdwan_core_vnic_attachment,
  ]
}
