resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}


resource "aws_security_group" "db_security_group" {
  name        = "${var.db_identifier}-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"] # adjust based on your environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}


resource "aws_db_instance" "knex_prod_db" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_storage
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_security_group.id]
  multi_az                = var.multi_az
#  availability_zone       = var.availability_zone
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = 7
  backup_window           = "19:00-20:00"
  maintenance_window      = "sat:22:00-sat:23:00"
  deletion_protection     = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  auto_minor_version_upgrade     = false

  tags = {
    env      = var.env
    workflow = var.workflow
  }
}

