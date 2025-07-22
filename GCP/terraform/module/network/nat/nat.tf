resource "google_compute_router_nat" "nat" {
  name                               = var.nat_gateway_name
  router                             = var.router_name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = var.nat_ips
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}