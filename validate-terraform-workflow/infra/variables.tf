/**
Primitive Types
string: Text sequences in double quotes or heredoc syntax.
number: Whole numbers or decimal values.
bool: True or false logical values.

Collection Types
list: A sequence of values ordered by index, all of the same type.
set: A collection of unique, unordered values.
map: A group of key-value pairs of the same type.

Structural Types
object: A structured collection of named attributes with individual types.
tuple: An ordered sequence of elements where each position can have a distinct type.
**/

variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "ecommerce"
}

variable "db_username" {
  description = "Nome do usuário do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_url" {
  description = "URL do banco de dados"
  type        = string
  default     = "jdbc:postgresql://localhost"
}

variable "db_port" {
  description = "Porta do banco de dados"
  type        = number
  default     = 5432
}

variable "db_schema" {
  description = "Nome do schema do banco de dados"
  type        = string
  default     = "public"
}