variable "target_compartment_id" {
  description = "OCID of the compartment where the VCN is being created"
  type        = string
}

variable "vcn_name" {
  description = "vcn name"
  type        = string
}

variable "common_tags" {
  description = "Tags"
  type        = map(string)
}

variable "create_new_pmm_vcn" {
  default     = false
  description = "Create a new VCN?"
  type        = bool
}

variable "vcn_id" {
  description = "existing vcn id"
  type        = string
  default     = "tbd"
}

variable "pg_subnet_id" {
  description = "existing pg subnet id"
  type        = string
  default     = "tbd"
}

variable "pg_private_subnet_id" {
  description = "existing pg subnet id"
  type        = string
  default     = "tbd"
}