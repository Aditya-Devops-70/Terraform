
module "network_vpc" {
  source               = "../../modules/network/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_instance_tenancy = var.vpc_instance_tenancy
  env                  = var.env
  vpc_name             = var.vpc_name
}

module "subnet1" {
  source                  = "../../modules/network/subnet"
  subnet_name             = var.subnet1_name
  subnet_cidr_block       = var.subnet1_cidr_block
  vpc_id                  = module.network_vpc.vpc_id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  env                     = var.env
  subnet_az = var.subnet1_az
    tags = {
    Name = var.subnet1_name
    env = var.env
 }
}

module "subnet2" {
  source            = "../../modules/network/subnet"
  subnet_name       = var.subnet2_name
  subnet_cidr_block = var.subnet2_cidr_block
  vpc_id            = module.network_vpc.vpc_id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  env               = var.env
  subnet_az = var.subnet2_az
  tags = {
    Name = var.subnet2_name
    env = var.env
 }
}

module "subnet3" {
  source            = "../../modules/network/subnet"
  subnet_name       = var.subnet3_name
  subnet_cidr_block = var.subnet3_cidr_block
  vpc_id            = module.network_vpc.vpc_id 
  map_public_ip_on_launch = var.map_public_ip_on_launch
  env               = var.env
  subnet_az = var.subnet3_az
    tags = {
    Name = var.subnet3_name
    env = var.env
 }
}

module "public_subnet" {
  source            = "../../modules/network/subnet"
  subnet_name       = var.subnet_public_name
  subnet_cidr_block = var.subnet_public_cidr_block
  vpc_id            = module.network_vpc.vpc_id 
  map_public_ip_on_launch = var.map_public_ip_on_launch_1
  env               = var.env
  subnet_az = var.subnet_public_az
    tags = {
    Name = var.subnet_public_name
    env = var.env
 }
}

module "public_subnet_2" {
  source            = "../../modules/network/subnet"
  subnet_name       = var.subnet_public2_name
  subnet_cidr_block = var.subnet_public2_cidr_block
  vpc_id            = module.network_vpc.vpc_id 
  map_public_ip_on_launch = var.map_public_ip_on_launch_1
  env               = var.env
  subnet_az = var.subnet_public2_az
    tags = {
    Name = var.subnet_public2_name
    env = var.env
 }
}

module "public_subnet_3" {
  source            = "../../modules/network/subnet"
  subnet_name       = var.subnet_public3_name
  subnet_cidr_block = var.subnet_public3_cidr_block
  vpc_id            = module.network_vpc.vpc_id 
  map_public_ip_on_launch = var.map_public_ip_on_launch_1
  env               = var.env
  subnet_az = var.subnet_public3_az
    tags = {
    Name = var.subnet_public3_name
    env = var.env
 }
}


module "internet_gateway" {
  source   = "../../modules/network/igw"
  vpc_id   = module.network_vpc.vpc_id
  igw_name = var.igw_name
}

module "eip" {
  source     = "../../modules/network/eip"
  depends_on = [module.internet_gateway]
}

module "nat_gateway" {
  source        = "../../modules/network/nat-gw"
  depends_on    = [module.internet_gateway]
  allocation_id = module.eip.allocation_id
  subnet_id     = module.public_subnet.subnet_id
  nat_gw_name   = var.nat_gw_name
}

module "route_table_public" {
  source        = "../../modules/network/route-table-public"
  vpc_id        = module.network_vpc.vpc_id
  ig_gateway_id = module.internet_gateway.aws_internet_gateway_id
  route_name    = var.route_name
}

module "route_table_private" {
  source         = "../../modules/network/route-table-private"
  vpc_id         = module.network_vpc.vpc_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
  nat_route_name = var.nat_route_name
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = module.public_subnet.subnet_id
  route_table_id = module.route_table_public.aws_route_table_id
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = module.public_subnet_2.subnet_id
  route_table_id = module.route_table_public.aws_route_table_id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = module.public_subnet_3.subnet_id
  route_table_id = module.route_table_public.aws_route_table_id
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = module.subnet1.subnet_id
  route_table_id = module.route_table_private.aws_route_table_id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = module.subnet2.subnet_id
  route_table_id = module.route_table_private.aws_route_table_id
}

resource "aws_route_table_association" "private_subnet_association_3" {
  subnet_id      = module.subnet3.subnet_id
  route_table_id = module.route_table_private.aws_route_table_id
}


############################################### Iam Role For Eks ############################################################


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
 
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ])
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}


resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
}]
  })
}


resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}


####################################################### eks ###########################################################################

module "eks_cluster" {
  source             = "../../modules/compute/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  role_arn           = resource.aws_iam_role.eks_cluster_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
}

module "eks_nodegroup" {
  source                = "../../modules/compute/nodegroup"
  cluster_name          = var.cluster_name
  node_group_name       = var.node_group_name
  node_role_arn         = resource.aws_iam_role.eks_node_role.arn
  node_group_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  node_desired_size     = var.node_desired_size
  node_max_size         = var.node_max_size
  node_min_size         = var.node_min_size
  instance_types        = var.instance_types
  role_arn = resource.aws_iam_role.eks_node_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  vpc_id = module.network_vpc.vpc_id
  disk_size = var.disk_size
  ami = var.ami
}

module "eks_nodegroup_argo" {
  source                = "../../modules/compute/nodegroup"
  cluster_name          = var.cluster_name
  node_group_name       = var.node_group_name_argo
  node_role_arn         = resource.aws_iam_role.eks_node_role.arn
  node_group_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  node_desired_size     = var.node_desired_size_argo
  node_max_size         = var.node_max_size_argo
  node_min_size         = var.node_min_size_argo
  instance_types        = var.instance_types
  role_arn = resource.aws_iam_role.eks_node_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  vpc_id = module.network_vpc.vpc_id
  disk_size = var.disk_size
  ami = var.ami
    node_labels = {
        purpose      = "argocd"
        nodegroup    = "knex-staging-cluster-argocd-ng"
  }
}

module "eks_nodegroup_prometheus" {
  source                = "../../modules/compute/nodegroup"
  cluster_name          = var.cluster_name
  node_group_name       = var.node_group_name_prometheus
  node_role_arn         = resource.aws_iam_role.eks_node_role.arn
  node_group_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  node_desired_size     = var.node_desired_size_prometheus
  node_max_size         = var.node_max_size_prometheus
  node_min_size         = var.node_min_size_prometheus
  instance_types        = var.instance_types
  role_arn = resource.aws_iam_role.eks_node_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  vpc_id = module.network_vpc.vpc_id
  disk_size = var.disk_size
  ami = var.ami
    node_labels = {
        purpose      = "prometheus"
        nodegroup    = "knex-staging-cluster-prometheus-ng"
  }
}

############################################################ eks2 #############################################################

module "eks_cluster_1" {
  source             = "../../modules/compute/eks"
  cluster_name       = var.cluster_name_1
  cluster_version    = var.cluster_version
  role_arn           = resource.aws_iam_role.eks_cluster_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
}

module "eks_nodegroup_1" {
  source                = "../../modules/compute/nodegroup"
  cluster_name          = var.cluster_name_1
  node_group_name       = var.node_group_name
  node_role_arn         = resource.aws_iam_role.eks_node_role.arn
  node_group_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  node_desired_size     = var.node_desired_size_1
  node_max_size         = var.node_max_size
  node_min_size         = var.node_min_size
  instance_types        = var.instance_types
  role_arn = resource.aws_iam_role.eks_node_role.arn
  private_subnet_ids = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  vpc_id = module.network_vpc.vpc_id
  disk_size = var.disk_size
  ami = var.ami
}


module "ecr_repository" {
  source = "../../modules/storage/ecr"
  ecr_repo_name = var.ecr_repo_name
}

################################################## rds ######################################################

module "rds" {
  source                = "../../modules/storage/rds"
  db_identifier         = var.db_identifier
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  db_max_storage        = var.db_max_storage
  engine_version        = var.engine_version
  subnet_ids            = [module.subnet1.subnet_id, module.subnet2.subnet_id]
  vpc_id                = module.network_vpc.vpc_id
  publicly_accessible   = var.publicly_accessible
  multi_az              = var.multi_az
  env                   = var.env
  workflow              = var.workflow

}

##########################################################################################################################

# module "subnet4" {
#   source            = "../modules/network/subnet"
#   subnet_name       = var.subnet4_name
#   subnet_cidr_block = var.subnet4_cidr_block
#   vpc_id            = module.network_vpc.vpc_id
#   env               = var.env
#   subnet_az = var.subnet4_az
#     tags = {
#     Name = var.subnet4_name
#     env = var.env
# }
  
# }

# module "subnet5" {
#   source                  = "../modules/network/subnet"
#   subnet_name             = var.subnet5_name
#   subnet_cidr_block       = var.subnet5_cidr_block
#   vpc_id                  = module.network_vpc.vpc_id
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   env                     = var.env
#   subnet_az = var.subnet5_az
#   tags = {
#     Name = var.subnet5_name
#     env = var.env
# }
# }


# module "subnet6" {
#   source                  = "../../modules/network/subnet"
#   subnet_name             = var.subnet6_name
#   subnet_cidr_block       = var.subnet6_cidr_block
#   vpc_id                  = module.network_vpc.vpc_id
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   env                     = var.env
#   subnet_az = var.subnet6_az
#   tags = {
#     Name = var.subnet6_name
#     env = var.env
#     "kubernetes.io/role/elb" = 1
# }

# }
# module "subnet7" {
#   source                  = "../../modules/network/subnet"
#   subnet_name             = var.subnet7_name
#   subnet_cidr_block       = var.subnet7_cidr_block
#   vpc_id                  = module.network_vpc.vpc_id
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   env                     = var.env
#   subnet_az = var.subnet7_az
#   tags = {
#     Name = var.subnet7_name
#     env = var.env
#     "kubernetes.io/role/elb" = 1
# }

# }

# module "aws_security_group_jump_server" {
#   source  = "../../modules/network/security_group"
#   vpc_id  = module.network_vpc.vpc_id
#   sg_name = var.sg_name
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_jump" {
#   security_group_id = module.aws_security_group_jump_server.security_group_id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_jump" {
#   security_group_id = module.aws_security_group_jump_server.security_group_id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# #---------
# module "aws_security_group_rds" {
#   source  = "../../modules/network/security_group"
#   vpc_id  = module.network_vpc.vpc_id
#   sg_name = var.rds_sg_name
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_mysql_rds" {
#   security_group_id = module.aws_security_group_rds.security_group_id
#   cidr_ipv4         = "10.20.16.0/20"
#   from_port         = 3306
#   ip_protocol       = "tcp"
#   to_port           = 3306
# }
# resource "aws_vpc_security_group_ingress_rule" "allow_custom" {
#   security_group_id = module.aws_security_group_rds.security_group_id
#   cidr_ipv4         = "10.20.0.0/20"
#   from_port         = 3306
#   ip_protocol       = "tcp"
#   to_port           = 3306
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_rds" {
#   security_group_id = module.aws_security_group_rds.security_group_id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# #------------------------------------
# resource "aws_key_pair" "jump_ssh_key" {
#   key_name   = "jump-server-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWJ9ebocz3rMowMx9tUl7JZIFgiBh+Jgl4SnwceIPVuNT//wi5WfYbszBOTJ6YsoCalpPjZ8fGGsTGgEtz88Jh5ubmLjyh+WVowjwODrDv4OesO4MCrW3nYsWTUtmdVKAz+sTfKW8XveeO5sPQsH0uDwx0RzvE7TmSZFlMs2nXBouryP/UL7ByC+LaN/yGoYkkxHm2HceNaQdrKDxjEdOInFtoCs2pvSNzPoslJfv7fTHU1McVMxHxeXbqsrxEoiEM96bubg3Ak3WZk3KlWrb+fvqlxB9K24DzlIqcRzCfKNRaHBoAQbuNd0wP0NvK3cTxfj1dtMyA2FbfS+GXIic/ ubuntu"
# }


# #https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/5.6.1?tab=inputs#

# module "ec2-instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.6.1"
#   # insert the 4 required variables here
#   ami                         = "ami-0ad21ae1d0696ad58"
#   instance_type               = var.jump_instance_type
#   name                        = var.jump_instance_name
#   vpc_security_group_ids      = tolist([module.aws_security_group_jump_server.security_group_id])
#   associate_public_ip_address = true
#   subnet_id                   = module.subnet1.subnet_id
#   tags = {
#     env = var.env
#   }
#   key_name = aws_key_pair.jump_ssh_key.key_name
#   root_block_device = [{
#     volume_type           = "gp3"
#     volume_size           = 100
#     delete_on_termination = true
#   }]
# }


# resource "aws_route_table_association" "subnet_association_2" {
#   subnet_id      = module.subnet6.subnet_id
#   route_table_id = module.route_table_public.aws_route_table_id
# }
# resource "aws_route_table_association" "subnet_association_3" {
#   subnet_id      = module.subnet7.subnet_id
#   route_table_id = module.route_table_public.aws_route_table_id
# }
# resource "aws_route_table_association" "subnet_association_nat" {
#   subnet_id      = module.subnet2.subnet_id
#   route_table_id = module.route_table_private.aws_route_table_id
# }
# resource "aws_route_table_association" "subnet_association_nat1" {
#   subnet_id      = module.subnet3.subnet_id
#   route_table_id = module.route_table_private.aws_route_table_id
# }
# resource "aws_route_table_association" "subnet_association_nat2" {
#   subnet_id      = module.subnet4.subnet_id
#   route_table_id = module.route_table_private.aws_route_table_id
# }
# resource "aws_route_table_association" "subnet_association_nat3" {
#   subnet_id      = module.subnet5.subnet_id
#   route_table_id = module.route_table_private.aws_route_table_id
# }


# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.20.0"

#   cluster_name    = var.cluster_name
#   cluster_version = var.cluster_version

#   cluster_endpoint_public_access = true

#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id                   = module.network_vpc.vpc_id
#   subnet_ids               = [module.subnet2.subnet_id, module.subnet3.subnet_id]
#   control_plane_subnet_ids = [module.subnet2.subnet_id, module.subnet3.subnet_id]

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["t3a.large"],
#     disk_size      = 100
#   }

#   eks_managed_node_groups = {
#     qa-node-group = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = ["t3a.large"]

#       min_size     = 1
#       max_size     = 1
#       desired_size = 1
#       block_device_mappings = {
#         xvda = {
#           device_name = "/dev/xvda"
#           ebs = {
#             volume_size           = 100
#             volume_type           = "gp3"
#             throughput            = 125
#             encrypted             = true
#             delete_on_termination = true
#           }
#         }
#       }
#       subnet_ids               = [module.subnet2.subnet_id]
#     }
#   }

#   # Cluster access entry
#   # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true

#   access_entries = {
#     # One access entry with a policy associated
#     access_entry = {
#       kubernetes_groups = []
#       principal_arn     = "arn:aws:iam::024848478618:user/ashish-sela"

#       policy_associations = {
#         eks_policy = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#           access_scope = {
#             # namespaces = ["default"]
#             type       = "cluster"
#           }
#         }
#       }
#     }
#   }

#   tags = {
#     Environment = "prod"
#     Terraform   = "true"
#   }
# }



# #---------------------------------------------------------------------------
# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "main"
#   subnet_ids = [module.subnet4.subnet_id,module.subnet5.subnet_id]

#   tags = {
#     Name = "DB subnet group"
#   }
# }
# #-----------------------------------------------------------------------------------
# module "rds1" {
#   source              = "../../modules/storage/rds"
#   db_name             = var.db_name
#   identifier          = var.identifier
#   engine_name         = var.engine_name
#   engine_version      = var.engine_version
#   instance_class      = var.instance_class
#   username            = var.username
#   password            = var.password
#   deletion_protection = var.deletion_protection

#   allocated_storage     = var.allocated_storage
#   #max_allocated_storage = var.max_allocated_storage

#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

#   allow_major_version_upgrade = var.allow_major_version_upgrade
#   auto_minor_version_upgrade  = var.auto_minor_version_upgrade

#   maintenance_window = var.maintenance_window
#   blue_green_update  = var.blue_green_update

#   license_model          = var.license_model
#   multi_az               = var.multi_az
#   # availability_zone      = var.availability_zone
#   port                   = var.port
#   storage_type           = var.storage_type
#   # iops = var.iops
#   # storage_throughput     = var.storage_throughput
#   network_type           = var.network_type
#   publicly_accessible    = var.publicly_accessible
#   vpc_security_group_ids = tolist([module.aws_security_group_rds.security_group_id])

#   backup_retention_period  = var.backup_retention_period
#   backup_target            = var.backup_target
#   backup_window            = var.backup_window
#   delete_automated_backups = var.delete_automated_backups

#   copy_tags_to_snapshot = var.copy_tags_to_snapshot

#   enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

#   monitoring_interval = var.monitoring_interval

#   env = var.env
# }


