output "test_vpc_name" {
  description = "The name of the VPC"
  value       = module.test_vpc.vpc_name
}

output "test_subnet_name" {
  description = "The name of the subnet"
  value       = module.test_subnet.subnet_name
}

output "test_subnet_cidr" {
  description = "The CIDR block of the subnet"
  value       = module.test_subnet.subnet_cidr
}

output "test_cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.test_gke.cluster_name
}

output "test_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.test_gke.cluster_endpoint
}

output "test_node_pool_name" {
  description = "The name of the node pool"
  value       = module.test_node_pool.node_pool_name
}

output "test_nat_router_name" {
  value = module.test_nat_router.router_name
}
output "test_nat_ip_address" {
  value = module.test_nat_ip.static_ip_address
}
output "test_nat_ip_self_link" {
  value = module.test_nat_ip.static_ip_address_self_link
}


output "artifact_registry_sa_email" {
  value = module.artifact_sa.email
}


