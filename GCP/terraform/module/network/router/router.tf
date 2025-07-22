resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = var.vpc_id
  bgp {
    advertise_mode    = "DEFAULT"
    keepalive_interval = 20
    asn = 64514
  }
}
