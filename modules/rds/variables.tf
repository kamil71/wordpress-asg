#variable "region" {
#  description = "us-east-1"
#}

variable "aws_region" {
 description = "name of aws region"
}

variable "environment" {
  description = "The Deployment environment"
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}


variable "database_username" {
  description = "DB username"
}

variable "database_password" {
  description = "DB Passowrd"
}

variable "database_name" {
  description = "DB Name"
}

variable "key_name" {
  description = "key Name"
}

variable "vpc_id" {
  description = "vpc id"
}

variable "subnets" {
  description = "subnets"
}

variable "security_groups" {
  description = "subnets"
}


variable "private_subnet_ids" {
  description = "subnets"
}
