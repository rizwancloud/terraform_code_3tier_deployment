resource "aws_db_subnet_group" "main" {
  name       = "db-${var.name_prefix}"
  subnet_ids = var.subnet-private-db

  tags = { Name = "${var.name_prefix}-db-subnets" }
}

resource "aws_db_instance" "main" {
  identifier             = "db-${var.name_prefix}"
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_encrypted      = true
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.db-sg
  multi_az               = var.db_multi_az
  publicly_accessible    = false
  skip_final_snapshot    = var.db_skip_final_snapshot

  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.name_prefix}-db-final"

  tags = { Name = "${var.name_prefix}-db" }
}
