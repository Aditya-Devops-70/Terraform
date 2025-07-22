resource "google_compute_firewall" "test_firewall" {
  name    = var.firewall_name
  network = var.network

  direction     = "INGRESS"
  source_ranges = var.source_ranges
  target_tags   = var.target_tags

  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  description = var.description
}
