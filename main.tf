provider "aws" {
  region  = var.aws_region
  profile = "terraform"
}

module "vpc" {
  source = "./modules/vpc"
  //AWS 
#  region      = var.region
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  vpc_cidr = "10.20.0.0/16"
  database_username = "${var.database_username}"
  database_password = "var.database_password"
  database_name     = "${var.database_name}"
  key_name          = var.key_name
}


module "alb" {
  source = "./modules/alb"
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = module.asg.ec2-instance-sg
}


module "asg" {
  source = "./modules/asg"
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  vpc_cidr = "10.20.0.0/16"
  db_endpoint = module.rds.rds-endpoint
  database_username = "${var.database_username}"
  database_password = "${var.database_password}"
  database_name     = "${var.database_name}"
  key_name          = var.key_name
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = module.asg.ec2-instance-sg
  lb_target_group_arn = module.alb.aws-alb-target-group-arn
  efs_id1 = module.efs.efs-kamil
}


module "efs" {
  source = "./modules/efs"
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  vpc_cidr = "10.20.0.0/16"
  database_username = "${var.database_username}"
  database_password = "var.database_password"
  database_name     = "${var.database_name}"
  key_name          = var.key_name
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  security_groups = module.asg.ec2-instance-sg
}


module "rds" {
  source = "./modules/rds"
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  vpc_cidr = "10.20.0.0/16"
  database_username = "${var.database_username}"
  database_password = "${var.database_password}"
  database_name     = "${var.database_name}"
  key_name          = var.key_name
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  security_groups = module.asg.ec2-instance-sg
}