data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}


locals {
  pg_state_id = random_string.state_id.id
}

# Create NSG for PostgreSQL
resource "oci_core_network_security_group" "postgresql_nsg" {
  count          = var.create_new_pg_db ? 1 : 0
  compartment_id = var.vcn_compartment_id
  vcn_id         = var.vcn_id
  display_name   = "postgresql-nsg-${local.pg_state_id}"
}

# Add ingress rule for PostgreSQL port (5432)
resource "oci_core_network_security_group_security_rule" "postgresql_ingress" {
  count                     = var.create_new_pg_db ? 1 : 0
  network_security_group_id = oci_core_network_security_group.postgresql_nsg[0].id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = data.oci_core_vcn.vcn.cidr_block
  description               = "Allow PostgreSQL traffic on port 5432 inside VCN"

  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}

resource "oci_psql_db_system" "postgres" {
  count          = var.create_new_pg_db ? 1 : 0
  compartment_id = var.vcn_compartment_id
  credentials {
    password_details {
      password_type = "PLAIN_TEXT"
      password      = var.pg_password
    }
    username = var.pg_username
  }
  db_version   = var.pg_version
  display_name = "${var.pg_instance_name}-${local.pg_state_id}"
  network_details {
    subnet_id                  = var.pg_subnet_id
    nsg_ids                    = [oci_core_network_security_group.postgresql_nsg[0].id]
    is_reader_endpoint_enabled = true
  }

  storage_details {
    is_regionally_durable = false
    system_type           = "OCI_OPTIMIZED_STORAGE"
    availability_domain   = data.oci_identity_availability_domain.ad.name
  }

  shape                       = var.pg_instance_shape
  instance_count              = var.pg_instance_count
  instance_ocpu_count         = var.pg_instance_ocpu_count
  instance_memory_size_in_gbs = var.pg_instance_memory_size_in_gbs
}

