locals {
  common_tags = {
    Reference = "oci-dev-tools"
  }
}

module "network" {
  source                = "./modules/network"
  target_compartment_id = var.compartment_ocid
  common_tags           = local.common_tags
  create_new_pmm_vcn    = var.create_new_pmm_vcn

  # optional variables
  vcn_name             = var.vcn_name
  vcn_id               = var.vcn_id
  pg_subnet_id         = var.pg_subnet_id
  pg_private_subnet_id = var.pg_private_subnet_id
}

module "compute" {
  source                   = "./modules/compute"
  region                   = var.region
  tenancy_ocid             = var.tenancy_ocid
  target_compartment_id    = var.compartment_ocid
  instance_shape           = var.instance_shape
  instance_display_name    = var.instance_display_name
  generate_ssh_key_pair    = var.generate_ssh_key_pair
  ssh_public_key           = var.ssh_public_key
  use_tenancy_level_policy = "false"
  common_tags              = local.common_tags

  vcn_id = var.create_new_pmm_vcn ? (
    module.network.vcn.id
  ) : (
    var.vcn_id # Use input variable if network is NOT created
  )

  subnet_id = var.create_new_pmm_vcn ? (
    module.network.subnet.id
  ) : (
    var.pg_subnet_id # Use input variable for existing subnet ID
  )
}

module "postgres" {  
  source                = "./modules/postgres"
  tenancy_ocid          = var.tenancy_ocid
  vcn_compartment_id    = var.compartment_ocid
  create_new_pg_db      = var.create_new_pg_db
  
  vcn_id = var.create_new_pmm_vcn ? (
    module.network.vcn_id
  ) : (
    var.vcn_id # Use input variable if network is NOT created
  )

  pg_subnet_id = var.create_new_pmm_vcn ? (
    module.network.private-subnet.id
  ) : (
    var.pg_private_subnet_id # Use input variable for existing subnet ID
  )

  # Optional, otherwise defaults are used
  pg_instance_name               = var.pg_instance_name
  pg_instance_count              = var.pg_instance_count
  pg_username                    = var.pg_username
  pg_password                    = var.pg_password
  pg_version                     = var.pg_version
  pg_instance_shape              = var.pg_instance_shape
  pg_instance_ocpu_count         = var.pg_instance_ocpu_count
  pg_instance_memory_size_in_gbs = var.pg_instance_memory_size_in_gbs
}