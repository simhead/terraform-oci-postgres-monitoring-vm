# Data source to look up an existing VCN by name
data "oci_core_vcns" "existing" {
  # This block is only processed when we are NOT creating a new VCN
  count          = var.create_new_pmm_vcn ? 0 : 1 
  compartment_id = local.compartment_id
  
  # Filter to find the VCN with the display name provided
  display_name   = var.vcn_name
  state          = "AVAILABLE"
}

data "oci_core_subnet" "existing_regional_sn" {
  # Only run this if we are NOT creating a new VCN
  count          = var.create_new_pmm_vcn ? 0 : 1
  subnet_id      = var.pg_subnet_id
}

data "oci_core_subnet" "existing_private_sn" {
  # Only run this if we are NOT creating a new VCN
  count          = var.create_new_pmm_vcn ? 0 : 1
  subnet_id      = var.pg_private_subnet_id
}

locals {
  compartment_id    = var.target_compartment_id
  display_name      = var.vcn_name
  vcn_dns_label     = "ocidevtools"
  vcn_cidr_block    = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  subnet_cidr_priv  = "10.0.2.0/24"
  all_cidr          = "0.0.0.0/0"

  vcn_id = var.create_new_pmm_vcn ? (
    oci_core_vcn.this[0].id # Use the newly created VCN's ID
  ) : (
    data.oci_core_vcns.existing[0].id
  )

  vcn = var.create_new_pmm_vcn ? (
    oci_core_vcn.this[0]
  ) : (
    data.oci_core_vcns.existing[0]
  )

  regional_subnet_object = var.create_new_pmm_vcn ? (
    oci_core_subnet.regional_sn[0] 
  ) : (
    data.oci_core_subnet.existing_regional_sn[0]
  )

  private_subnet_object = var.create_new_pmm_vcn ? (
    oci_core_subnet.private_sn[0] 
  ) : (
    data.oci_core_subnet.existing_private_sn[0]
  )
}

# VCN
resource "oci_core_vcn" "this" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = local.compartment_id
  cidr_block     = local.vcn_cidr_block
  display_name   = "${local.display_name}-vcn"
  dns_label      = local.vcn_dns_label
  freeform_tags  = var.common_tags
}

# internet gateway to connect to compute instance - internet gateway is for the VCN

resource "oci_core_internet_gateway" "ig" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = local.compartment_id                     # Required
  vcn_id         = local.vcn_id                             # Required
  display_name   = "${local.display_name}-internet-gateway" # Optional
  freeform_tags  = var.common_tags
}

resource "oci_core_nat_gateway" "nat" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = var.target_compartment_id
  vcn_id         = local.vcn_id
  display_name   = "${local.display_name}-NAT-gateway"
  freeform_tags  = var.common_tags
}

resource "oci_core_service_gateway" "sgw" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = var.target_compartment_id
  vcn_id         = local.vcn_id
  display_name   = "${local.display_name}-SGW"
  freeform_tags  = var.common_tags
  
  # Crucial block: This is the service you want to enable access to.
  # The 'All' option is the most common for a private subnet.
  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}

resource "oci_core_route_table" "rt" { #TODO - change the name to "rt" instead of "subnet"
  count          = var.create_new_pmm_vcn ? 1 : 0 # count          = local.use_existing_vcn ? 0 : 1
  compartment_id = local.compartment_id
  vcn_id         = local.vcn_id
  display_name   = "${local.display_name}-route-table"

  route_rules {
    destination       = local.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig[count.index].id
  }

  freeform_tags = var.common_tags
}

# Data source to find the OCID for the 'All services in region'
data "oci_core_services" "all_services" {
  # No arguments are required here. It automatically queries for services in the provider's region.
}

resource "oci_core_route_table" "private_rt" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = var.target_compartment_id
  vcn_id         = local.vcn_id
  display_name   = "${local.display_name}-private-route-table"

  route_rules {
    destination       = local.all_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat[count.index].id # Direct traffic to the NAT GW
  }

  route_rules {
    # Rule B: Route to Service Gateway (OCI Services like Object Storage)
    destination       = data.oci_core_services.all_services.services[0].cidr_block # Uses the CIDR for 'All Services'
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw[count.index].id
  }

  freeform_tags  = var.common_tags
}

resource "oci_core_security_list" "sl" {
  count          = var.create_new_pmm_vcn ? 1 : 0
  compartment_id = local.compartment_id                  # Required
  vcn_id         = local.vcn_id                          # Required
  display_name   = "${local.display_name}-security-list" # Optional
  freeform_tags  = var.common_tags

  # Intentionally left ingress and egress rules blank. Expected to set the NSG at the instance level
}

#subnet
resource "oci_core_subnet" "regional_sn" {
  count             = var.create_new_pmm_vcn ? 1 : 0
  cidr_block        = local.subnet_cidr_block        # Required
  compartment_id    = var.target_compartment_id      # Required
  vcn_id            = local.vcn_id                   # Required
  route_table_id    = oci_core_route_table.rt[count.index].id     # Optional - But Required in this case to associate the above created Route table
  security_list_ids = [oci_core_security_list.sl[count.index].id] # Optional - defined a security list that has NO ingress and egress rules
  display_name      = "${local.display_name}-subnet" # Optional
  freeform_tags     = var.common_tags
}

# The private subnet definition
resource "oci_core_subnet" "private_sn" {
  count             = var.create_new_pmm_vcn ? 1 : 0
  cidr_block        = local.subnet_cidr_priv  # Required 
  compartment_id    = var.target_compartment_id        # Required (Same compartment)
  vcn_id            = local.vcn_id                     # Required (Same VCN)  
  route_table_id    = oci_core_route_table.private_rt[count.index].id       # Optional, using the same RT for simplicity  
  security_list_ids = [oci_core_security_list.sl[count.index].id]   # Optional
  prohibit_public_ip_on_vnic = true
  
  display_name      = "${local.display_name}-private-subnet" # Optional - clearly label it as private
  freeform_tags     = var.common_tags

}