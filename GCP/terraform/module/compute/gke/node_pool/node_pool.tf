# Separately Managed Node Pool
resource "google_container_node_pool" "np" {
  name       = var.node_pool_name
  cluster    = var.cluster_name
  location   = var.node_pool_region
  node_locations =  var.node_locations
  
  node_count = var.gke_num_nodes

  autoscaling {
    total_max_node_count = var.max_node_count
    total_min_node_count  = var.min_node_count
  }

  network_config {
    enable_private_nodes = true  
  }

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type
    disk_type = "pd-standard"
    disk_size_gb = var.disk_size_gb
    
    service_account = var.service_account_id
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.environment
    }

    tags         = ["gke-node", "${var.environment}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
