resource "oci_core_network_security_group" "nsg" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.prisma_sdwan_vcn_id : oci_core_vcn.prisma_sdwan.0.id
  display_name = var.nsg_display_name
}

resource "oci_core_network_security_group_security_rule" "rule_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_all" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction = "INGRESS"
  protocol  = "all"
  source    = "0.0.0.0/0"
}


resource "oci_core_network_security_group" "nsg_application" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.application_vcn_id : oci_core_vcn.application.0.id
  display_name = var.web_nsg_display_name
}

resource "oci_core_network_security_group_security_rule" "web_rule_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_application.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "web_rule_ingress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_application.id
  direction = "INGRESS"
  protocol  = "all"
  source    = "0.0.0.0/0"
}
