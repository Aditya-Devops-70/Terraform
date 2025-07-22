resource "google_compute_address" "static_ip" {
  name   = var.ip_address_name
  region = var.ip_address_region
}