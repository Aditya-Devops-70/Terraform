variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
 
variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}
 
variable "role_arn" {
  description = "IAM role"
  type        = string
}


variable "private_subnet_ids" {
  description = "Private subnets for control plane"
  type        = list(string)
}