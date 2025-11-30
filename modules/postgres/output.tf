output "postgres_hostname" {
  description = "The hostname for connecting to the primary PostgreSQL instance. Blank if the DB system is not created."
  value = try(
    oci_psql_db_system.postgres[0].instances[0].id,
    ""
  )
}

output "postgres_db_system_id" {
  description = "The OCID of the provisioned OCI PostgreSQL DB System. Blank if the DB system is not created."
  value = try(
    oci_psql_db_system.postgres[0].id,
    ""
  )
}

output "postgres_admin_password" {
  description = "The administrative password for the PostgreSQL DB System."
  value = var.create_new_pg_db ? var.pg_password : "DB_NOT_CREATED"
  sensitive   = true
}

output "postgres_connection_url_template" {
  description = "A standard PostgreSQL connection URL template (use this for psql/applications)."
  value = try(
    format("postgresql://%s:<PASSWORD>@%s:5432/postgres", 
      var.pg_username, 
      oci_psql_db_system.postgres[0].instances[0].id
    ),
    "DB_NOT_CREATED"
  )
}

output "postgres_private_ip" {
  description = "The private IP address of the primary PostgreSQL instance."
  value = try(
    oci_psql_db_system.postgres[0].network_details[0].primary_db_endpoint_private_ip,
    ""
  )
}