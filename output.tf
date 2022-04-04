output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets_ids" {
  value = module.vpc.public_subnets
}

output "private_subnets_ids" {
  value =  module.vpc.private_subnets
}

output "default_sg_id" {
  value = module.asg.ec2-instance-sg
}

output "security_groups_ids" {
  value = "module.asg.aws_security_group.ec2-instance-sg.id"
}

output "public_route_table" {
  value = "module.vpc.aws_route_table.public.id"
}


output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name1
}

output "efs_id" {
  description = "The DNS name of the load balancer."
  value       = module.efs.efs-kamil
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value = module.rds.rds-endpoint
}