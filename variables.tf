variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}

variable "instance_shape" {
  description = "Shape of the instance"
  type        = string
}

variable "instance_display_name" {
  description = "Name of the instance"
  type        = string
}

variable "generate_ssh_key_pair" {
  description = "Auto-generate SSH key pair"
  type        = string
}

variable "ssh_public_key" {
  description = "ssh public key used to connect to the compute instance"
  default     = "" # This value has to be defaulted to blank, otherwise terraform apply would request for one.
  type        = string
}

variable "vcn_name" {
  description = "vcn name"
  type        = string
  default     = "pmm-vm-vcn"
}

variable "vcn_id" {
  description = "vcn id"
  type        = string
  default     = "tbd"
}

variable "pg_subnet_id" {
  description = "pg subnet id"
  type        = string
  default     = "tbd"
}

variable "pg_private_subnet_id" {
  description = "existing pg subnet id"
  type        = string
  default     = "tbd"
}

variable "create_new_pmm_vcn" {
  default     = false
  description = "Create a new VCN?"
  type        = bool
}

# variable "use_tenancy_level_policy" {
#   description = "Compute instance to access all resources at tenancy level"
#   type        = bool
# }
variable "create_new_pg_db" {
  default     = false
  description = "Create A Postgres DB?"
  type        = bool
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

variable "pmm_shell_link" { 
  description = "Link for running pmm shell script e.g. https://www.percona.com/get/pmm"
  type        = string
  default = "https://www.percona.com/get/pmm"
}