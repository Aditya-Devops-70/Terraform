variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC id where subnet get created"
  default = ""
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}


variable "pod_ip_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
  default     = "pods"
}

variable "pod_ip_cidr" {
  description = "The CIDR block for the secondary IP range for pods"
  type        = string
  default     = "" # Example CIDR block
}

variable "service_ip_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
  default     = "services"
}

variable "service_ip_cidr" {
  description = "The CIDR block for the secondary IP range for services"
  type        = string
  default     = "" # Example CIDR block
}

variable "enabled_private_service_access" {
  default = true
}

#################################################################################################################




variable "private_ip_google_access" {
  type    = bool
  default = true
}
 
variable "secondary_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}