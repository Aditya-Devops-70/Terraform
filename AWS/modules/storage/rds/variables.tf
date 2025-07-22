# variables.tf
variable "db_identifier" {
  description = "RDS identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username for the DB"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the DB"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "DB instance class (e.g. db.r5.xlarge)"
  type        = string
}

variable "db_allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
}

variable "db_max_storage" {
  description = "Maximum allocated storage in GB"
  type        = number
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}

# variable "availability_zone" {
#   description = "Preferred availability zone"
#   type        = string
# }

variable "env" {
  description = "Environment tag"
  type        = string
}

variable "workflow" {
  description = "Workflow tag"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}