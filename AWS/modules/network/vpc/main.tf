resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_instance_tenancy

  tags = {
    Name = var.vpc_name
    env = var.env
  }
}
