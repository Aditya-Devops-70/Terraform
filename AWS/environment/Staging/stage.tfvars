# Vpc Configuration

vpc_name             = "knex-staging-vpc"
env                  = "knex-staging"
vpc_cidr             = "172.16.0.0/16"
vpc_instance_tenancy = "default"
region = "ap-south-1"


# Subnet 1 configuration
subnet1_name       = "staging-private-subnet-1"
subnet1_cidr_block = "172.16.1.0/24"
subnet1_az         = "ap-south-1a"

# Whether to auto-assign public IPs to instances in this subnet
map_public_ip_on_launch = false
map_public_ip_on_launch_1 = true

# Subnet 2 configuration
subnet2_name       = "staging-private-subnet-2"
subnet2_cidr_block = "172.16.2.0/24"
subnet2_az         = "ap-south-1b"

# Subnet 3 configuration
subnet3_name       = "staging-private-subnet-3"
subnet3_cidr_block = "172.16.3.0/24"
subnet3_az         = "ap-south-1c"

# public Subnet configuration
subnet_public_name       = "staging-public-subnet-1"
subnet_public_cidr_block = "172.16.4.0/24"
subnet_public_az         = "ap-south-1a"

subnet_public2_name       = "staging-public-subnet-2"
subnet_public2_cidr_block = "172.16.5.0/24"
subnet_public2_az         = "ap-south-1b"

subnet_public3_name       = "staging-public-subnet-3"
subnet_public3_cidr_block = "172.16.6.0/24"
subnet_public3_az         = "ap-south-1c"
########################################################################################

igw_name           = "knex-staging-igw"
nat_gw_name        = "knex-staging-nat"
route_name         = "public-ig-rt"
nat_route_name     = "private-nat-rt"


####################################### eks #################################################


cluster_name    = "knex-staging-cluster"
cluster_version = "1.32"

node_desired_size   = 2      #1
node_max_size       = 10
node_min_size       = 1
instance_types      = ["t3.xlarge"]  # t2.medium
disk_size = 100
ami = "AL2023_x86_64_STANDARD"
node_group_name = "knex-staging-cluster-node-group"


################################################ Argo_node #########################################
node_group_name_argo     = "knex-staging-cluster-argocd-ng"
node_desired_size_argo   = 1      #1
node_max_size_argo       = 3
node_min_size_argo       = 1

######################################### Promethus node #################################################
node_group_name_prometheus     = "knex-staging-cluster-prometheus-ng"
node_desired_size_prometheus   = 1      #1
node_max_size_prometheus       = 3
node_min_size_prometheus       = 1
########################################### eks2 ###############################################

cluster_name_1    = "knex-staging-cluster-new"
node_desired_size_1   = 1


######################################### ecr #######################################################

ecr_repo_name = "knex-staging-repository"


########################################## RDS ######################################################

db_identifier         = "knex-prod-postgres"
db_name               = "knexdb"
db_username           = "knexadmin"
db_password           = ""  
db_instance_class     = "db.t3.large"
db_allocated_storage  = 100
db_max_storage        = 200
engine_version        = "16.8"
publicly_accessible   = false
multi_az              = true     #You can't specify a fixed availability_zone when multi_az = true — AWS automatically chooses 2 AZs for high availability.
workflow              = "n8n"

#########################################################################################################


# #-------------------------------------
# subnet4_name       = "knex-staging-db"
# subnet4_cidr_block = "10.20.48.0/20"
# subnet4_az = "ap-south-1c"
# #---------------------------------
# subnet5_name       = "knex-staging-db1"
# subnet5_cidr_block = "10.20.64.0/20"
# subnet5_az = "ap-south-1b"
# #--------------------------------
# subnet6_name       = "knex-lb"
# subnet6_cidr_block = "10.20.80.0/20"
# subnet6_az = "ap-south-1a"
# #---------------------------------
# subnet7_name       = "knex-lb1"
# subnet7_cidr_block = "10.20.96.0/20"
# subnet7_az = "ap-south-1b"
# #----------------------------------------
# jump_instance_name = "jump-server"
# jump_instance_type = "t3a.large"
# sg_name            = "jump_instance_security_group"



# #-----------------------------------
# #------------------------------------

# #-----------------------------------
# db_name                         = "knex-staging_db"
# identifier                      = "knex-staging-db"
# engine_name                     = "mysql"
# engine_version                  = "8.0"
# instance_class                  = "db.r6g.2xlarge"
# username                        = "knexknex-staging"
# password                        = "Mi3ql#123"
# deletion_protection             = true
# allocated_storage               = 100
# max_allocated_storage           = 600
# # db_subnet_group_name            = "knex-staging-db-subnet"
# allow_major_version_upgrade     = false
# auto_minor_version_upgrade      = true
# maintenance_window              = "Mon:00:00-Mon:03:00"
# blue_green_update               = true
# license_model                   = "general-public-license"
# multi_az                        = false
# availability_zone               = "ap-south-1a"
# port                            = "3306"
# storage_type                    = "gp3"
# storage_throughput              = "3000"
# network_type                    = "IPV4"
# publicly_accessible             = false
# # vpc_security_group_ids          = var.vpc_security_group_ids
# backup_retention_period         = 7
# backup_target                   = "region"
# backup_window                   = "09:46-10:16"
# delete_automated_backups        = true
# copy_tags_to_snapshot           = true
# enabled_cloudwatch_logs_exports = ["error"]
# monitoring_interval             = 0
# iops = 1000
# rds_sg_name = "rds_security_group"
# #---------------------------------------------

# #----------------------------------