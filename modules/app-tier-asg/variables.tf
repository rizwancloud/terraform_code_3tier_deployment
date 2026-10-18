variable "azs" {
  description = "Two Availability Zones (1a and 1b of your region)"
  type        = list(string)
}
variable "name_prefix" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "asg_config" {
  type = object({ min = number, desired = number, max = number })
}
variable "asg_cpu_target" {
  type = number
}
variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  description = "db password"
  type        = string
  sensitive   = true
}
variable "db_name" {
  type = string
}
variable "app-sg" {
  type = list(string)
}
variable "cloudwatch" {
  type = string
}
variable "endpoint" {
  type = string
}
variable "subnet-private-app" {
  type = list(string)
}
variable "target_app" {
  type = string
}