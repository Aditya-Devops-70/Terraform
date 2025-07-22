variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
 
variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = ""
}
 
variable "node_group_name" {
  description = "node_group_name"
  type        = string
}

variable "role_arn" {
  description = "IAM role"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS node group"
  type        = string
}
 
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
 
variable "private_subnet_ids" {
  description = "Private subnets for control plane"
  type        = list(string)
}
 
variable "node_group_subnet_ids" {
  description = "Subnets to place managed nodes (AZs)"
  type        = list(string)
}

variable "instance_types" {
  description = "Node instance types"
  type        = list(string)
  default     = ["t3.xlarge"]
}
 
variable "node_desired_size" {
  type    = number
  default = "2"
}
 
variable "node_min_size" {
  type    = number
  default = "1"
}
 
variable "node_max_size" {
  type    = number
  default = "10"
}

variable "disk_size" {
  type    = number
  default = "100"
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "node_labels" {
  description = "Labels to apply to the EKS nodes"
  type        = map(string)
  default     = {}
}