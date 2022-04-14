#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

####################################
#  Prisma SDWAN Variable Group   #
####################################

variable "prisma_sdwan_custom_image_ocid" {
  description = "Custom Image OCID"
}

variable branch_cidr {
 description = "SDWAN Branch CIDR"
 default = "192.168.0.0/16"
}

variable branch_sdwan_supernet { 
  description = "Branch Supernet CIDR"
  default = "192.168.20.0/23"

}
############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "Prisma-SDWAN-ION"
}

variable "vm_display_name_application" {
  description = "Instance Name"
  default     = "application-vm"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.8" //4 cores
}

variable "spoke_vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 4
}

variable "spoke_vm_flex_shape_ocpus" {
  description = "Spoke VMs Flex Shape OCPUs"
  default     = 4
}
variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "ssh_public_key" {
  description = "SSH Public Key String"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "PARAVIRTUALIZED"
}

############################
#  Network Configuration   #
############################

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "prisma_sdwan_vcn_id" {
  default = ""
}

variable "application_vcn_id" {
  default = ""
}

variable "prisma_sdwan_vcn_display_name" {
  description = "Prisma SDWAN VCN Name"
  default     = "prisma-sdwan-vcn"
}

variable "prisma_sdwan_vcn_cidr_block" {
  description = "Prisma SDWAN VCN CIDR"
  default     = "172.16.255.0/24"
}

variable "prisma_sdwan_vcn_dns_label" {
  description = "Prisma SDWAN VCN DNS Label"
  default     = "prismasdwan"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "prisma_sdwan_controller_subnet_id" {
  default = ""
}

variable "prisma_sdwan_controller_subnet_display_name" {
  description = "Prisma SDWAN Controller Subnet Name"
  default     = "prisma-sdwan-controller-subnet"
}

variable "prisma_sdwan_controller_subnet_cidr_block" {
  description = "Prisma SDWAN Controller Subnet CIDR"
  default     = "172.16.255.0/28"
}

variable "prisma_sdwan_controller_subnet_dns_label" {
  description = "Prisma SDWAN Controller Subnet DNS Label"
  default     = "prismacontl"
}

variable "prisma_sdwan_core_subnet_id" {
  default = ""
}

variable "prisma_sdwan_core_subnet_display_name" {
  description = "Prisma SDWAN Core Subnet Name"
  default     = "prisma-sdwan-core-subnet"
}

variable "prisma_sdwan_core_subnet_cidr_block" {
  description = "Prisma SDWAN Core Subnet CIDR"
  default     = "172.16.255.32/28"
}

variable "prisma_sdwan_core_subnet_dns_label" {
  description = "Prisma SDWAN Core Subnet DNS Label"
  default     = "prismacore"
}

variable "prisma_sdwan_public_subnet_id" {
  default = ""
}

variable "prisma_sdwan_public_subnet_display_name" {
  description = "Prisma SDWAN Public Subnet Name"
  default     = "prisma-sdwan-public-subnet"
}

variable "prisma_sdwan_public_subnet_cidr_block" {
  description = "Prisma SDWAN Public Subnet CIDR"
  default     = "172.16.255.16/28"
}

variable "prisma_sdwan_public_subnet_dns_label" {
  description = "Prisma SDWAN Public Subnet DNS Label"
  default     = "prismapublic"
}

variable "application_vcn_cidr_block" {
  description = "Application VCN CIDR Block"
  default     = "172.16.0.0/24"
}

variable "application_vcn_dns_label" {
  description = "Application VCN DNS Label"
  default     = "application"
}

variable "application_vcn_display_name" {
  description = "Application VCN Display Name"
  default     = "application-vcn"
}

variable "application_compute_subnet_id" {
  default = ""
}

variable "application_compute_subnet_cidr_block" {
  description = "Application VCN Private Subnet"
  default     = "172.16.0.0/28"
}

variable "application_compute_subnet_display_name" {
  description = "Application VCN Private Subnet Display Name"
  default     = "application-compute-subnet"
}

variable "application_compute_subnet_dns_label" {
  description = "Application VCN DNS Label"
  default     = "application"
}

############################
# Additional Configuration #
############################

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "cluster-security-group"
}

variable "web_nsg_display_name" {
  description = "Network Security Groups - Web"
  default     = "web-security-group"
}

variable "public_routetable_display_name" {
  description = "Public route table Name"
  default     = "UntrustRouteTable"
}

variable "private_routetable_display_name" {
  description = "Private route table Name"
  default     = "TrustRouteTable"
}

variable "drg_routetable_display_name" {
  description = "DRG route table Name"
  default     = "DRGRouteTable"
}

variable "use_existing_ip" {
  description = "Use an existing permanent public ip"
  default     = "Create new IP"
}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default     = "prisma-sdwan"
}

variable "template_version" {
  description = "Template version"
  default     = "20200724"
}

######################
#    Enum Values     #   
######################
variable "network_strategy_enum" {
  type = map
  default = {
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}

variable "subnet_type_enum" {
  type = map
  default = {
    transit_subnet    = "Private Subnet"
    MANAGEMENT_SUBENT = "Public Subnet"
  }
}

variable "nsg_config_enum" {
  type = map
  default = {
    BLOCK_ALL_PORTS = "Block all ports"
    OPEN_ALL_PORTS  = "Open all ports"
    CUSTOMIZE       = "Customize ports - Post deployment"
  }
}
