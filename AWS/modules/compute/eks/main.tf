resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.role_arn
 
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}