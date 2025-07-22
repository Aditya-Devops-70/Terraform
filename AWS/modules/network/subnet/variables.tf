
variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs"
  type        = bool
}

variable "env" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
}

variable "subnet_az" {
  description = "Availability Zone for the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the subnet"
  type        = map(string)
  default     = {}
}
