variable "name_prefix" { type = string }
variable "db_engine" { type = string }
variable "db_instance_class" { type = string }
variable "db_allocated_storage" { type = number }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_port" { type = number }
variable "db_multi_az" { type = bool }
variable "db_skip_final_snapshot" { type = bool }
variable "subnet-private-db" {
  type = list(string)
}
variable "db-sg" {
  type = list(string)
}