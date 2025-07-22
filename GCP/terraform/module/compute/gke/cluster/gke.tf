resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.region_or_zone_name  # must be a region like "asia-south1"  for regional cluster  
  network            = var.network
  subnetwork         = var.subnetwork
  initial_node_count = var.node_count
  remove_default_node_pool = true
  

# Disable deletion protection to allow cluster deletion
  deletion_protection = false

  # Private Cluster Settings
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    master_global_access_config {
      enabled = true
    }
  }

  # Master Authorized Networks
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  control_plane_endpoints_config{
    dns_endpoint_config {
      allow_external_traffic = true
    }
  }

  monitoring_config {
    managed_prometheus {
      enabled = false
    }
  }

  # IP Allocation Policy for Pods and Services
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_ip_range_name
    services_secondary_range_name = var.service_ip_range_name
  }

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}