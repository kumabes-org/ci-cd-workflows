resource "aws_ssm_parameter" "database_configuration" {
  name  = var.name
  type  = var.type
  value = var.value
}