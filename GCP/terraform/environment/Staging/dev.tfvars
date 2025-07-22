####PROJECT
project_id              = "test-uat-env"
environment             = "uat"

#######NETWORK
####VPC
region                  = "asia-south1"
vpc_name                = "test-vpc"

####SUBNET
subnet_name             = "test-pri-subnet1"
subnet_cidr             = "10.10.0.0/20"
region_or_zone_name     = "asia-south1-a"

public_subnet_1_cidr = "10.10.16.0/20"
public_subnet_1_name = "test-public-subnet-1"

public_subnet_2_name = "test-public-subnet-2"
public_subnet_2_cidr = "10.10.32.0/20"

public_subnet_3_name = "test-public-subnet-3"
public_subnet_3_cidr = "10.10.48.0/20"

private_subnet_1_name = "test-private-subnet-1"
private_subnet_1_cidr = "10.10.64.0/20"

private_subnet_2_name = "test-private-subnet-2"
private_subnet_2_cidr = "10.10.80.0/20"



####NAT
nat_ip_address_name = "test-nat-ip"
test_nat_name = "test-nat-gateway"
test_nat_router_region = "asia-south1"

####GKE
cluster_name            = "test-gke-cluster"
node_pool_name          = "test-node-pool"
machine_type            = "e2-medium"
node_count              = 1
enable_private_nodes    = true
enable_private_endpoint = false
master_authorized_networks = [
  {
    cidr_block   = "192.168.1.0/24"
    display_name = "corporate-office"
  },
  {
    cidr_block   = "14.141.60.58/32"
    display_name = "sela-office-01"
  },
  {
    cidr_block   = "182.72.58.210/32"
    display_name = "sela-office-02"
  }
]

master_ipv4_cidr_block = "172.16.0.0/28"

test_secondary_ranges        = [
  {
    range_name = "pods"
    ip_cidr_range = "10.1.0.0/16"
  },
  {
    range_name = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
]


####Node Pool
##test node pool
plnp_node_pool_name = "test-node-pool"
plnp_machine_type   = "e2-medium"

# #Namespace
# #provider = "kubernetes"
# namespace_finbingo = "finbingo"
# namespace_test = "test"
# namespace_nginx = "nginx"


##############################################################################################################################

vm_1 = {
  machine_name = "test-jump-server"
  machine_type  = "e2-medium"
  image_family  = "ubuntu-2204-lts"
  image_project = "ubuntu-os-cloud"
  network       = "test-vpc"
  subnetwork    = "test-public-subnet-1"  
}

# vm_2 = {
#   machine_name  = "test-postgres"
#   machine_type  = "e2-medium"
#   image_family  = "ubuntu-2204-lts"
#   image_project = "ubuntu-os-cloud"
#   network       = "test-vpc"
#   subnetwork    = "test-pri-subnet1"
#   zone          = "asia-south1-b"
# }

# vm_3 = {
#   machine_name  = "test-mongo"
#   machine_type  = "e2-medium"
#   image_family  = "ubuntu-2204-lts"
#   image_project = "ubuntu-os-cloud"
#   network       = "test-vpc"
#   subnetwork    = "test-pri-subnet1"
#   zone          = "asia-south1-c"
# }

################################################################################################################################

#region      = "us-central1"
repo_id     = "test-uat-repo"
#environment = "dev"

#project_id       = "your-project-id"
sa_name          = "artifact-registry-sa"
sa_display_name  = "Artifact Registry SA"



