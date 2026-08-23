resource "aws_ssm_parameter" "database_configuration" {
  db_name     = var.db_name
  db_username = var.db_username
  db_url      = var.db_url
  db_port     = var.db_port
  db_schema   = var.db_schema
}