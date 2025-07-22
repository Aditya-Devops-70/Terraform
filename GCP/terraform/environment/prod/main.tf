##VPC
module "test_vpc" {
  source      = "../../module/network/vpc"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  vpc_name    = var.vpc_name

}

##########################################################################################################


##GKE SUBNET
module "test_subnet" {
  depends_on = [module.test_vpc]
  source = "../../module/network/subnet"
  project_id = var.project_id
  region = var.region
  environment = var.environment
  vpc_id = module.test_vpc.vpc_id
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  secondary_ranges       = var.test_secondary_ranges
}


module "public_subnet_1" {
  depends_on = [module.test_vpc]
  source     = "../../module/network/subnet"
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  vpc_id     = module.test_vpc.vpc_id
  subnet_name = var.public_subnet_1_name
  subnet_cidr = var.public_subnet_1_cidr
  private_ip_google_access = false
  secondary_ranges = []
}

module "public_subnet_2" {
  depends_on = [module.test_vpc]
  source     = "../../module/network/subnet"
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  vpc_id     = module.test_vpc.vpc_id
  subnet_name = var.public_subnet_2_name
  subnet_cidr = var.public_subnet_2_cidr
}


module "public_subnet_3" {
  depends_on = [module.test_vpc]
  source     = "../../module/network/subnet"
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  vpc_id     = module.test_vpc.vpc_id
  subnet_name = var.public_subnet_3_name
  subnet_cidr = var.public_subnet_3_cidr
}

module "private_subnet_1" {
  depends_on = [module.test_vpc]
  source     = "../../module/network/subnet"
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  vpc_id     = module.test_vpc.vpc_id
  subnet_name = var.private_subnet_1_name
  subnet_cidr = var.private_subnet_1_cidr
}

module "private_subnet_2" {
  depends_on = [module.test_vpc]
  source     = "../../module/network/subnet"
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  vpc_id     = module.test_vpc.vpc_id
  subnet_name = var.private_subnet_2_name
  subnet_cidr = var.private_subnet_2_cidr
}



##############################################################################################################################



module "vm_1" {
  source        = "../../module/compute/vm"
  machine_name = var.vm_1.machine_name
  machine_type  = var.vm_1.machine_type
  image_family  = var.vm_1.image_family
  image_project = var.vm_1.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.public_subnet_1.subnet_name
  zone          = var.region_or_zone_name
  boot_disk_size_gb = 20 
  assign_public_ip  = true
}


module "vm_2" {
  source        = "../../module/compute/vm"
  machine_name  = var.vm_2.machine_name
  machine_type  = var.vm_2.machine_type
  image_family  = var.vm_2.image_family
  image_project = var.vm_2.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.test_subnet.subnet_name
  zone          = var.region_or_zone_name_b
  boot_disk_size_gb = 30
  assign_public_ip  = false
}


module "vm_3" {
  source        = "../../module/compute/vm"
  machine_name  = var.vm_3.machine_name
  machine_type  = var.vm_3.machine_type
  image_family  = var.vm_3.image_family
  image_project = var.vm_3.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.test_subnet.subnet_name
  zone          = var.region_or_zone_name_c
  boot_disk_size_gb = 30
  assign_public_ip  = false  
}

module "vm_4" {
  source        = "../../module/compute/vm"
  machine_name  = var.vm_4.machine_name
  machine_type  = var.vm_4.machine_type
  image_family  = var.vm_4.image_family
  image_project = var.vm_4.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.test_subnet.subnet_name
  zone          = var.region_or_zone_name_c
  boot_disk_size_gb = 30
  assign_public_ip  = false  
}

module "vm_5" {
  source        = "../../module/compute/vm"
  machine_name  = var.vm_5.machine_name
  machine_type  = var.vm_5.machine_type
  image_family  = var.vm_5.image_family
  image_project = var.vm_5.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.test_subnet.subnet_name
  zone          = var.region_or_zone_name_c
  boot_disk_size_gb = 30
  assign_public_ip  = false  
}


module "vm_6" {
  source        = "../../module/compute/vm"
  machine_name  = var.vm_6.machine_name
  machine_type  = var.vm_6.machine_type
  image_family  = var.vm_6.image_family
  image_project = var.vm_6.image_project
  network       = module.test_vpc.vpc_name
  subnetwork    = module.test_subnet.subnet_name
  zone          = var.region_or_zone_name_c
  boot_disk_size_gb = 50
  assign_public_ip  = false  
}

module "artifact_repo" {
  source      = "../../module/storage/artifact"
  region      = var.region
  repo_id     = var.repo_id
  environment = var.environment
}



module "artifact_sa" {
  source           = "../../module/service"
  project_id       = var.project_id
  sa_name          = var.sa_name
  sa_display_name  = var.sa_display_name
}





####################################################################################################################################

##NAT ROUTER
module "test_nat_router" {
  source = "../../module/network/router"
  router_name = var.test_nat_router_name
  region = var.test_nat_router_region
  vpc_id = module.test_vpc.vpc_id
}

##NAT IP
module "test_nat_ip" {
  source = "../../module/network/ip_address"
  ip_address_name = var.nat_ip_address_name
  ip_address_region = var.test_nat_router_region
}

##NAT
module "test_nat" {
  depends_on = [ module.test_nat_ip, module.test_nat_router ]
  source = "../../module/network/nat"
  nat_gateway_name = var.test_nat_name
  router_name = module.test_nat_router.router_name
  region = var.test_nat_router_region
  nat_ips = [module.test_nat_ip.static_ip_address_self_link]
  
}

##GKE CLUSTER
module "test_gke" {
  source              = "../../module/Compute/gke/cluster"
  depends_on          = [module.test_vpc] # Add dependencies if needed
  project_id          = var.project_id
  region              = var.region
  region_or_zone_name = var.region_or_zone_name
  network             = module.test_vpc.vpc_name
  subnetwork          = module.test_subnet.subnet_name
  environment         = var.environment
  cluster_name        = var.cluster_name
  node_pool_name      = var.node_pool_name
  machine_type        = var.machine_type
  node_count          = var.node_count
  enable_private_nodes = var.enable_private_nodes
  enable_private_endpoint = var.enable_private_endpoint
  master_authorized_networks = var.master_authorized_networks
  pod_ip_range_name    ="pods"
  service_ip_range_name = "services"
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
}

##GKE NODE POOL
module "test_node_pool" {
  depends_on         = [ module.test_gke ]
  source             = "../../module/compute/gke/node_pool"
  environment        = var.environment
  node_pool_name     = var.plnp_node_pool_name
  node_pool_region   = var.region_or_zone_name
  gke_num_nodes      = 1
  project_id         = var.project_id
  machine_type       = var.plnp_machine_type
  cluster_name       = var.cluster_name
  service_account_id = var.service_account_id
  max_node_count     = 20
  min_node_count     = 1
  preemptible        = false
  node_locations = ["asia-south1-a"] # Replace with your region zones
  disk_size_gb = 30
}




module "allow_http" {
  source = "../../module/network/firewall"

  firewall_name = "allow-http"
  network       = module.test_vpc.vpc_name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["80"]
    }
  ]
}


module "allow_https" {
  source = "../../module/network/firewall"

  firewall_name = "allow-https"
  network       = module.test_vpc.vpc_name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]

  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["443"]
    }
  ]
}


module "test_internal_allow" {
  source = "../../module/network/firewall"

  firewall_name          = "test-allow-internal-traffic"
  network       = module.test_vpc.vpc_name
  source_ranges = [
    "10.0.0.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
  target_tags = ["allow-internal"]  # Or [] to apply to all VMs

  allow_rules = [
    {
      protocol = "all"
      ports    = [] # Empty list for "all" doesn't matter
    }
  ]

  description = "Allow all internal traffic within test VPC from known subnets"
}


# ##GKE Namespace
# module "namespace_test" {
#   depends_on = [module.test_gke]
#   source = "../../module/compute/gke/namespace"
#   name = var.namespace_test
# }

# module "namespace_finbingo" {
#   depends_on = [module.test_gke]
#   source = "../../module/compute/gke/namespace"
#   name = var.namespace_finbingo
# }

# module "namespace_nginx" {
#   depends_on = [module.test_gke]
#   source = "../../module/compute/gke/namespace"
#   name = var.namespace_nginx
# }



############################################## database ##################################################################

module "cloudsql_postgres" {
  source = "../../module/cloudsql/postgres"

  project_id         = var.project_id
  region             = var.region
  db_instance_name   = var.db_instance_name
  db_tier            = var.db_tier
  db_version         = var.db_version
  db_user            = var.db_user
  db_password        = var.db_password
  db_name            = var.db_name
  db_private_network = var.db_private_network
  disk_size          = var.disk_size
  disk_type          = var.disk_type
  
}


