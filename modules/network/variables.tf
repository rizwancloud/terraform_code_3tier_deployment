variable "azs" {
  type = list(string)
}
variable "name_prefix" {
  type = string
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



