variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "asia-south1"
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "test-dev-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "test-dev-subnet"
}

variable "test_secondary_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet_1_name" {

  description = "public_subnet_1_name"
  type        = string
  
}

variable "public_subnet_2_name" {
  description = "public_subnet_2_name"
  type        = string
}



variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}


variable "public_subnet_3_name" {
  description = "public_subnet_3_name"
  type        = string
}

variable "public_subnet_3_cidr" {
  description = "CIDR block for public subnet 3"
  type        = string
}

variable "private_subnet_1_name" {
  description = "private_subnet_1_name"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "private_subnet_2_name" {
  description = "private_subnet_2_name"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
}


variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "region_or_zone_name" {
  description = "The GCP region or zone for the GKE cluster"
  type        = string
  default     = "asia-south1-a"  #need to change 
}

variable "region_or_zone_name_b" {
  description = "The GCP region or zone for the GKE cluster"
  type        = string
  default     = "asia-south1-b"  #need to change 
}

variable "region_or_zone_name_c" {
  description = "The GCP region or zone for the GKE cluster"
  type        = string
  default     = "asia-south1-c"  #need to change 
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "test-gke-cluster"
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
  default     = "test-node-pool"
}

variable "machine_type" {
  description = "The machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "The number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "enable_private_nodes" {
  description = "Enable private nodes for the GKE cluster"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the GKE cluster"
  type        = bool
  default     = true
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks to allow access to the control plane"
  type        = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}


variable "pod_ip_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
  default     = "pods"
}

variable "service_ip_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
  default     = "services"
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the control plane in a private cluster"
  type        = string
  default     = "172.16.0.0/28" # Example CIDR block
}


variable "service_ip_cidr" {
  description = "The CIDR block for the secondary IP range for services"
  type        = string
  default     = "10.2.0.0/16" # Example CIDR block
}

variable "pod_ip_cidr" {
  description = "The CIDR block for the secondary IP range for pods"
  type        = string
  default     = "10.1.0.0/16" # Example CIDR block
}

##Namespace
variable "namespace_test" {
  default = "test"
}
variable "namespace_finbingo" {
  default = "finbingo"
}
variable "namespace_nginx" {
  default = "nginx"
}

##GKE Node Pool
##NODE POOL : test-nodepool (plnp)
variable "plnp_node_pool_name" {
  default = "np-test"
}
variable "service_account_id" {
  default = ""
}
variable "plnp_machine_type" {
  default = "e2-medium"
}


####nat-router
variable "test_nat_router_name" {
  default = "test-nat-router"
}
variable "test_nat_router_region" {
  default = ""
}

####nat-ip
variable "nat_ip_address_name" {
  default = ""
}

variable "nat_ip_address_region" {
  default = ""
}
####nat
variable "test_nat_name" {
  default = ""
}
variable "test_nat_ips" {
  default = []
}


variable "vm_1" {
  type = object({
    machine_name          = string
    machine_type  = string
    image_family  = string
    image_project = string
    network       = string
    subnetwork    = string
    tags          = string
  })
}

variable "vm_2" {
  type = object({
    machine_name  = string
    machine_type  = string
    image_family  = string
    image_project = string
    network       = string
    subnetwork    = string
  })
}

variable "vm_3" {
  type = object({
    machine_name  = string
    machine_type  = string
    image_family  = string
    image_project = string
    network       = string
    subnetwork    = string
  })
}


variable "repo_id" {
  description = "Artifact Registry Repository ID"
  type        = string
}


variable "sa_name" {
  type        = string
  description = "Service account ID"
}

variable "sa_display_name" {
  type        = string
  description = "Service account display name"
}

