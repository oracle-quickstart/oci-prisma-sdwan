output "prisma_sdwan_ion_instance_public_ip" {
  value = [oci_core_instance.prisma-sdwan-vm[0].*.public_ip]
}

output "prisma_sdwan_ion_instance_private_ip" {
  value = [oci_core_instance.prisma-sdwan-vm[0].*.private_ip]
}

output "initial_instruction" {
value = <<EOT
1. Launch console connection. 
2. Configure virtual appliance parameters from CLI. 
3. Select option 4 for ION model. 
4. For additional details follow the official documentation.
EOT
}
