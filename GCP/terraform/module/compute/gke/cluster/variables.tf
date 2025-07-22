variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
}

variable "region_or_zone_name" {
  description = "The GCP region or zone for the GKE cluster"
  type        = string
}

variable "network" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnet"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the GKE nodes"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the node pool"
  type        = number
}

variable "enable_private_nodes" {
  description = "Enable private nodes for the GKE cluster"
  type        = bool
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the GKE cluster"
  type        = bool
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks to allow access to the control plane"
  type        = list(object({
    cidr_block   = string
    display_name = string
  }))
}

variable "pod_ip_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
}

variable "service_ip_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the control plane in a private cluster"
  type        = string
  default     = "172.16.0.0/28" # Example CIDR block
}