# resource "google_compute_subnetwork" "subnet" {
#   name          = var.subnet_name
#   ip_cidr_range = var.subnet_cidr
#   region        = var.region
#   network       = var.vpc_id
#   project       = var.project_id
#   private_ip_google_access = true

#     # Define secondary IP ranges for pods and services
#   secondary_ip_range {
#     range_name    = var.pod_ip_range_name
#     ip_cidr_range = var.pod_ip_cidr
#   }

#   secondary_ip_range {
#     range_name    = var.service_ip_range_name
#     ip_cidr_range = var.service_ip_cidr
#   }


# }




resource "google_compute_subnetwork" "subnet" {
  name = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region = var.region
  network = var.vpc_id
  project = var.project_id
  private_ip_google_access = var.private_ip_google_access
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ranges
    content {
      range_name = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}
 
