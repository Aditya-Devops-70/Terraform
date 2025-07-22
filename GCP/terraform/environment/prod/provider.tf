terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.24.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=4.80.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}


provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("./test-production-env-terraform.json")
}

data "google_client_config" "default" {}

data "google_container_cluster" "test_cluster" {
  name     = "test-gke-cluster"
  location = "asia-south1-a"
}

# provider "kubernetes" {
#   host                   = "https://${module.test_gke.cluster_endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
# }
# provider "kubectl" {
#   host                   = "https://${module.test_gke.test_cluster_endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
#   load_config_file       = false
# }
# provider "helm" {
#   kubernetes {
#     host                   = "https://${module.test_gke.test_cluster_endpoint}"
#     token                  = data.google_client_config.default.access_token
#     cluster_ca_certificate = base64decode(data.google_container_cluster.test_cluster.master_auth[0].cluster_ca_certificate)
#   }
# }