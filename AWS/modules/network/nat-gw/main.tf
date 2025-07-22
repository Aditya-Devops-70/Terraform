resource "aws_nat_gateway" "nat_gw" {
  allocation_id = var.allocation_id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.nat_gw_name
  }
}