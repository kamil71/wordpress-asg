#variable "region" {
#  description = "us-east-1"
#}

variable "aws_region" {
 description = "name of aws region"
}

variable "environment" {
  description = "The Deployment environment"
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
