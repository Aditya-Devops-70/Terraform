variable "environment" {
  default = ""
}
variable "node_pool_name" {
    default =""
}
variable "node_pool_region" {
    default = ""
  
}

variable "node_locations" {
  description = "List of zones in the region"
  type        = list(string)
}

variable "gke_num_nodes" {
  default = ""
}

variable "project_id" {
  default = ""
}

variable "machine_type" {
  default = ""
}

variable "disk_size_gb" {
  default = 50                        
}

variable "cluster_name" {
  default = ""
}

variable "preemptible" {
  default = ""
}

variable "service_account_id" {
  default = ""
}
variable "max_node_count" {
  default = 1
}
variable "min_node_count" {
  default = 1
}