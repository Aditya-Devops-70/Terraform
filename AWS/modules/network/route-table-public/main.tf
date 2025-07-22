resource "aws_route_table" "Public-ig-rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ig_gateway_id
  }
  tags = {
    Name = var.route_name
  }
}

