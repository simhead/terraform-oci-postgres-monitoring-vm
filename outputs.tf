output "compute_instance_public_ip" {
  value = module.compute.instance.public_ip
}

output "compartment_id" {
  value = var.compartment_ocid
}

output "generated_instance_ssh_private_key" {
  value = var.generate_ssh_key_pair ? module.compute.instance_keys.private_key_pem : ""
  sensitive = true
}

### DB related
output "db_system_hostname" {
  description = "The hostname for connecting to the OCI PostgreSQL DB System."
  value = module.postgres.postgres_hostname
}

output "db_system_private_ip" {
  description = "The private IP address of the primary PostgreSQL instance."
  value       = module.postgres.postgres_private_ip
}

output "db_system_ocid" {
  description = "The OCID of the PostgreSQL DB System resource."
  value       = module.postgres.postgres_db_system_id
}

output "db_admin_password_root" {
  description = "The administrative password (sensitive)."
  value       = module.postgres.postgres_admin_password
  sensitive   = true
}

output "db_system_connection_url" {
  description = "The full connection URL (with masked password)."
  value       = module.postgres.postgres_connection_url_template
  sensitive   = true
}