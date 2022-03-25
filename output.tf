output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnets_id" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
}

output "public_route_table" {
  value = aws_route_table.public.id
}

#output "server-public-ip" {
#  value       = aws_instance.myweb.*.public_ip
#  description = "Instance PublicIP"
#}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.lb.*.dns_name, [""])[0]
}
