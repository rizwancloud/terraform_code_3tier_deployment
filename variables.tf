variable "azs" {
  description = "availability zones for project"
  type        = list(string)
}

variable "name_prefix" {
  description = "project name"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr for this main vpc"
  type        = string
}

variable "vpc_name" {
  description = "name of vpc for easily cacheable for us"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "isolated network list of public subnet"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "isolated network list for application subnet"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "isolated network list for database subnet"
  type        = list(string)
}

variable "web_port" {
  type = number
}

variable "app_port" {
  type = number
}

variable "db_port" {
  type = number
}


variable "db_engine" { type = string }
variable "db_instance_class" { type = string }
variable "db_allocated_storage" { type = number }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_multi_az" { type = bool }
variable "db_skip_final_snapshot" { type = bool }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "asg_config" { type = object({ min = number, desired = number, max = number }) }
variable "asg_cpu_target" { type = number }