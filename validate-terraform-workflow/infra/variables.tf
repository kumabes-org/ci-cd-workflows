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

variable "name" {
  description = "(Required) Name of the parameter. If the name contains a path (e.g., any forward slashes (/)), it must be fully qualified with a leading forward slash (/). For additional requirements and constraints, see the AWS SSM User Guide."
  type        = string
}

variable "type" {
  description = "(Required) Type of the parameter. Valid types are String, StringList and SecureString."
  type        = string
}

variable "value" {
  description = "(Optional, exactly one of value, value_wo or insecure_value is required) Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type. In Terraform CLI version 0.15 and later, this may require additional configuration handling for certain scenarios. For more information, see the Terraform v0.15 Upgrade Guide."
  type        = string
}