
azs         = ["ap-south-1a", "ap-south-1b"]
name_prefix = "3tawt"


vpc_name                 = "3tawt"
vpc_cidr                 = "10.0.0.0/16"
public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
private_db_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]
web_port                 = 80
app_port                 = 4000
db_port                  = 3306

db_engine              = "mysql"
db_instance_class      = "db.t3.micro"
db_allocated_storage   = 10
db_name                = "threetawtdb"
db_username            = "admin"
db_password            = "1234AS!4"
db_multi_az            = false
db_skip_final_snapshot = true


ami_id        = "ami-08e3b3155fc937a94"
instance_type = "t3.micro"
asg_config = {
  min     = 2,
  desired = 2,
  max     = 4
}
asg_cpu_target = 70