variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "ecommerce"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "db_username" {
  type    = string
  default = "dbadmin"
}
variable "db_password" {
  type      = string
  sensitive = true
}
