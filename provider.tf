provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}

# for Home Region (Ashburn/IAD)
provider "oci" {
  alias        = "home"
  tenancy_ocid = var.tenancy_ocid
  region       = "us-ashburn-1" 
}

provider "tls" {

}

terraform {
  required_version = ">= 1.5"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0" # Or your preferred version
    }
  }
}
