resource "aws_db_instance" "route_rater_production" {
  identifier           = "my-db-instance"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  username             = "route_rater"
  password             = var.db_password
  parameter_group_name = "default.postgres16"
  publicly_accessible  = false
}

output "db_endpoint" {
  value = aws_db_instance.route_rater_production.endpoint
}