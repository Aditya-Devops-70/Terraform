output "static_ip_address" {
  value = google_compute_address.static_ip.address
}

output "static_ip_address_self_link" {
  value = google_compute_address.static_ip.self_link
}