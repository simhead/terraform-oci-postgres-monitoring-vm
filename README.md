ORM stack design for VM to support PostgreSQL Monitoring

Description:

The core objective is to create an ORM stack that provisions a VM-based infrastructure capable of hosting and monitoring a PostgreSQL database cluster, which involves infrastructure setup, PostgreSQL installation, and the integration of a monitoring solution (PMM - Percona Monitoring and Management).

### ORM Stack Base Infrastructure (Terraform)

This section defines the cloud resources provisioned via the Terraform files bundled in the ORM stack:

- Compute Instance: Provisioning of a Virtual Machine (VM) that will host the PostgreSQL database instance. This VM should be adequately sized for initial performance needs (CPU and RAM).
- Boot Volume: Provisioning of a dedicated block volume attached to the VM for PostgreSQL data storage, separate from the boot volume.
- Block Volume: Storing PMM server configuration data and these persisted data can be reused for other VMs.
- Networking: Creation or configuration of the necessary networking components:
- VCN and Subnets: Placing the VM in a public subnet but private subnet for PostgreSQL database instance.
- Database (PostgreSQL) Initial Setup: Installation of the PostgreSQL server package and basic configuration files.

### Shell Script Configuration (PMM Monitoring)

This section details the use of a "_local-exec_" (bootstrap.sh) to configure the database VM after it is provisioned.

### PMM (Percona Monitoring and Management) Integration

The shell script's primary role is to set up robust monitoring for the PostgreSQL instance:

- PMM Client Installation: The script must download and install the PMM Client (PMM Agent) package onto the PostgreSQL VM.
- Configuration: The script must configure the PMM Client to connect to the PMM Server (assuming the PMM Server is provisioned separately). This typically involves setting:
  - The PMM Server IP/Hostname.
  - Security credentials (API keys or tokens).
- Service Integration: The script registers the PostgreSQL service with the PMM Client, enabling data collection.

NOTE: manual setup is needed for running pmm-admin and to add postgresql.

- Start and Enable Service: The script ensures the PMM Client service is started and configured to run at boot.

### Stack Configuration

Default - using existing VCN
<TODO: add pic>
<TODO: add pic>

NOTE: choose DB's dedicated private zone is required

<TODO: add pic>
<TODO: add pic>
<TODO: add pic>
<TODO: add pic>

### For new VCN (Optional)

<TODO: add pic>
<TODO: add pic>

Define VCN name for VM instance:

This will create 2 subnets - public for VM instance and private for DB instance

### Stack Code

<https://github.com/simhead/terraform-oci-postgres-monitoring-vm.git>
