module "network" {
  source                   = "./modules/network"
  azs                      = var.azs
  vpc_cidr                 = var.vpc_cidr
  vpc_name                 = var.vpc_name
  name_prefix              = var.name_prefix
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  web_port                 = var.web_port
  app_port                 = var.app_port
  db_port                  = var.db_port
}

module "DB" {
  source                 = "./modules/DB"
  name_prefix            = var.name_prefix
  db_engine              = var.db_engine
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_port                = var.db_port
  db_multi_az            = var.db_multi_az
  db_skip_final_snapshot = var.db_skip_final_snapshot
  subnet-private-db      = module.network.network.private_db
  db-sg                  = [module.network.network.db-tier]
}

module "IAM-role" {
  source      = "./modules/IAM-role"
  name_prefix = var.name_prefix
}

module "web-tier-asg" {
  source         = "./modules/web-tier-asg"
  azs            = var.azs
  name_prefix    = var.name_prefix
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  asg_config     = var.asg_config
  asg_cpu_target = var.asg_cpu_target
  web-tier-sg    = [module.network.network.web-tier]
  cloudwatch     = module.IAM-role.cloudwatch
  dns_in-lb      = module.ALB.dns_name.internal
  subnet-public  = module.network.network.public
  target_web     = module.ALB.web
}

module "app-tier-asg" {
  source             = "./modules/app-tier-asg"
  azs                = var.azs
  name_prefix        = var.name_prefix
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  asg_config         = var.asg_config
  asg_cpu_target     = var.asg_cpu_target
  db_name            = var.db_name
  db_password        = var.db_password
  db_username        = var.db_username
  app-sg             = [module.network.network.app-tier]
  cloudwatch         = module.IAM-role.cloudwatch
  endpoint           = module.DB.main-db
  subnet-private-app = module.network.network.private_app
  target_app         = module.ALB.app
}

module "ALB" {
  source             = "./modules/ALB"
  web_port           = var.web_port
  app_port           = var.app_port
  name_prefix        = var.name_prefix
  vpc-id             = module.network.network.vpc_id
  subnet-public      = module.network.network.public
  subnet-private_app = module.network.network.private_app
  ex-lb-sg           = module.network.network.ex-lb
  in-lb-sg           = module.network.network.in-lb
}

module "cloudwatch_logs" {
  source = "./modules/cloudwatch"
}