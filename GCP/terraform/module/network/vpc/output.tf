output "vpc_name" {
  description = "The name of the VPC"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}