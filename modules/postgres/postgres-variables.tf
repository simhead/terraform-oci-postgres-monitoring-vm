# # Variables for Oracle PostgreSQL Autonomous Database (sample OCI-compatible names)
variable "tenancy_ocid" {}
variable "vcn_compartment_id" {
  type        = string
  description = "The compartment id where you want to create PMM VM vcn"
}

variable "vcn_id" {
  default     = null
  description = "VCN id for creating PMM VM network components."
  type        = string
}

variable "create_new_pg_db" {
  default     = false
  description = "Create A Postgres DB?"
  type        = bool
}

variable "pg_subnet_id" {
  description = "OCID of subnet for the Postgres database"
  type        = string
}

variable "pg_instance_name" {
  description = "Display name for the Postgres database"
  type        = string
  default     = "postgres-db"
}

variable "pg_instance_count" {
  description = "Starting number of PG instances (reader nodes)."
  default     = 1
}

variable "pg_username" {
  description = "PostgreSQL Username"
  default     = "admin"
}
variable "pg_password" {
  description = "PostgreSQL Password"
  default     = ""
}

variable "pg_version" {
  description = "PostgreSQL version"
  default     = 16
}

variable "pg_instance_shape" {
  description = "PostgerSQL Instanece Shape"
  default     = "PostgreSQL.VM.Standard.E5.Flex"
}

variable "pg_instance_ocpu_count" {
  description = "PostgerSQL Instanece OCPU Count"
  default     = 2
}

variable "pg_instance_memory_size_in_gbs" {
  description = "PostgerSQL Instanece Memory Size in GBs"
  default     = 32
}

# variable "pg_db_version" {
#   description = "The version of PostgreSQL to deploy (e.g. '14' or '15')"
#   type        = string
#   default     = "14"
# }

# variable "pg_admin_password" {
#   description = "Admin password for Postgres admin user"
#   type        = string
#   sensitive   = true
# }

# variable "pg_cpu_core_count" {
#   description = "Number of OCPUs for Postgres instance (min 1)"
#   type        = number
#   default     = 1
# }

# variable "pg_storage_gb" {
#   description = "Database storage size in GB"
#   type        = number
#   default     = 50
# }



# variable "pg_backup_retention_days" {
#   description = "Number of days to retain automatic backups"
#   type        = number
#   default     = 7
# }

# variable "pg_freeform_tags" {
#   description = "Freeform tags for Postgres resources"
#   type        = map(string)
#   default     = {}
# }

# variable "pg_username" {
#   description = "Admin username for the PostgreSQL DB system"
#   type        = string
# }

# variable "pg_password_type" {
#   description = "Type of password used for DB credentials ('PLAIN_TEXT' or 'VAULT_SECRET')"
#   type        = string
# }

# variable "pg_shape" {
#   description = "The compute shape for the PostgreSQL DB system (e.g. 'PostgreSQL.VM.Standard.E4.Flex.1.64GB')"
#   type        = string
# }

# variable "pg_is_regionally_durable" {
#   description = "Whether the storage is regionally durable (true/false)"
#   type        = bool
# }

# variable "pg_system_type" {
#   description = "The storage system type (e.g. 'EPHEMERAL' or 'LOCAL')"
#   type        = string
# }
