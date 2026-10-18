variable "web_port" {
  type = number
}
variable "name_prefix" {
  type = string
}
variable "app_port" {
  type = number
}
variable "vpc-id" {
  type = string
}
variable "subnet-public" {
  type = list(string)
}
variable "subnet-private_app" {
  type = list(string)
}
variable "ex-lb-sg" {
  type = string
}
variable "in-lb-sg" {
  type = string
}
