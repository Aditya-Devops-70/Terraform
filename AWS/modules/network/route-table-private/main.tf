resource "aws_route_table" "Private-nat-rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway_id
  }
  tags = {
    Name = var.nat_route_name
  }
}