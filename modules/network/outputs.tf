output "vcn_id" {
  description = "The OCID of the VCN, either newly created or existing."
  value       = local.vcn_id 
}

output "vcn" {
  description = "The full VCN resource object (only if newly created, otherwise empty)."
  # Use 'one' or 'try' to safely return the VCN object if it exists, otherwise an empty object.
  # This makes the output less prone to errors when count is 0.
  value = local.vcn
}

output "private-subnet" {
  value = local.private_subnet_object #oci_core_subnet.private_sn
}

output "subnet" {
  description = "The regional public subnet object (newly created resource or existing data object)."
  value = local.regional_subnet_object
}