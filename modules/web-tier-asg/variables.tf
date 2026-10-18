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
variable "web-tier-sg" {
  type = list(string)
}
variable "cloudwatch" {
  type = string
}
variable "dns_in-lb" {
  type = string
}
variable "subnet-public" {
  type = list(string)
}
variable "target_web" {
  type = string
}