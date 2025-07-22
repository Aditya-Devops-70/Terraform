################################# VPC ###########################################

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_instance_tenancy" {
  description = "The instance tenancy attribute for the VPC (default or dedicated)"
  type        = string
  default     = "default"
}

variable "region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_name" {
  description = "Name tag to assign to the VPC"
  type        = string
  default     = ""
}

#################################### Subnet ###########################################

variable "subnet1_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet1_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}


variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs"
  type        = bool
}

variable "map_public_ip_on_launch_1" {
  description = "Whether to auto-assign public IPs"
  type        = bool
}



variable "subnet1_az" {
  description = "Availability Zone for the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the subnet"
  type        = map(string)
  default     = {}
}

######################################## Subnet2 #############################################

variable "subnet2_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet2_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}


variable "subnet2_az" {
  description = "Availability Zone for the subnet"
  type        = string
}

######################################################### Subnet 3 ################################################
variable "subnet3_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet3_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}


variable "subnet3_az" {
  description = "Availability Zone for the subnet"
  type        = string
}


variable "subnet_public_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_public_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_public_az" {
  description = "Availability Zone for the subnet"
  type        = string
}


variable "subnet_public2_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_public2_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_public2_az" {
  description = "Availability Zone for the subnet"
  type        = string
}



variable "subnet_public3_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_public3_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_public3_az" {
  description = "Availability Zone for the subnet"
  type        = string
}
########################################################################################################


variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
}

variable "nat_gw_name" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "route_name" {
  description = "Name tag for the public route table"
  type        = string
}

variable "nat_route_name" {
  description = "Name tag for the private route table"
  type        = string
}


variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = ""
}



variable "node_desired_size" {
  description = "Desired size of the node group"
  type        = number
}

variable "node_max_size" {
  description = "Maximum size of the node group"
  type        = number
}

variable "node_min_size" {
  description = "Minimum size of the node group"
  type        = number
}

variable "instance_types" {
  description = "List of EC2 instance types"
  type        = list(string)
}

variable "disk_size" {
  type    = number
  default = "100"
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

############################################### Argo node #############################################################


variable "node_desired_size_argo" {
  description = "Desired size of the node group"
  type        = number
}

variable "node_max_size_argo" {
  description = "Maximum size of the node group"
  type        = number
}

variable "node_min_size_argo" {
  description = "Minimum size of the node group"
  type        = number
}

variable "node_labels" {
  description = "Labels to apply to the EKS nodes"
  type        = map(string)
  default     = {}
}

########################################## promethus node group #####################################################################


variable "node_desired_size_prometheus" {
  description = "Desired size of the node group"
  type        = number
}

variable "node_max_size_prometheus" {
  description = "Maximum size of the node group"
  type        = number
}

variable "node_min_size_prometheus" {
  description = "Minimum size of the node group"
  type        = number
}

variable "node_group_name_prometheus" {
  description = "node_group_name_prometheus"
  type        = string
}



#######################################################################################################################################


variable "cluster_name_1" {
  description = "The name of the EKS cluster"
  type        = string
}


variable "node_desired_size_1" {
  description = "Desired size of the node group"
  type        = number
}


variable "node_group_name" {
  description = "node_group_name"
  type        = string
}

variable "node_group_name_argo" {
  description = "node_group_name_argo"
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the AWS ECR repository"
  type        = string
  default     = ""
}


#################################################### RDS #########################################################

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


variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}


variable "workflow" {
  description = "Workflow tag"
  type        = string
}

#######################################################################################################





variable "subnet4_name" {
  default = "subnet name"
}
variable "subnet4_cidr_block" {
  default = ""
}
variable "subnet5_name" {
  default = "subnet name"
}
variable "subnet5_cidr_block" {
  default = ""
}
variable "subnet6_name" {
  default = "subnet name"
}
variable "subnet6_cidr_block" {
  default = ""
}
variable "subnet7_name" {
  default = "subnet name"
}
variable "subnet7_cidr_block" {
  default = ""
}

variable "subnet4_az" {
  default = ""
}
variable "subnet5_az" {
  default = ""
}
variable "subnet6_az" {
  default = ""
}
variable "subnet7_az" {
  default = ""
}

variable "jump_instance_name" {
  default = ""
}
variable "jump_instance_type" {
  default = ""
}
variable "sg_name" {
  default = ""
}

variable "allocation_id" {
  default = ""
}


#---------------------------------------

variable "identifier" {
  default = ""
}
variable "engine_name" {
  default = ""
}

variable "instance_class" {
  default = ""
}
variable "username" {
  default = ""
}
variable "password" {
  default = ""
}
variable "license_model" {
  default = "general-public-license"
}

variable "port" {
  default = "3315"
}
variable "storage_type" {
  default = "gp3"
}
variable "storage_throughput" {
  default = ""
}
variable "network_type" {
  default = "IPV4"
}
variable "vpc_security_group_ids" {
  default = ""
}
variable "allocated_storage" {
  default = ""
}
variable "max_allocated_storage" {
  default = ""
}
variable "allow_major_version_upgrade" {
  default = ""
}
variable "auto_minor_version_upgrade" {
  default = ""
}
variable "maintenance_window" {
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_retention_period" {
  default = ""
}
variable "backup_target" {
  default = ""
}
variable "backup_window" {
  default = ""
}
variable "blue_green_update" {
  default = true
}
variable "copy_tags_to_snapshot" {
  default = ""
}
variable "db_subnet_group_name" {
  default = ""
}
variable "delete_automated_backups" {
  default = ""
}
variable "deletion_protection" {
  default = true
}
variable "enabled_cloudwatch_logs_exports" {
  default = "error "
}
variable "monitoring_interval" {
  default = 60
}
variable "iops" {
  default = 1000
}
variable "rds_sg_name" {
  default = ""
}

#--------------------------------------
