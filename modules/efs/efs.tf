data "aws_availability_zones" "available" {
  state = "available"
}

// efs.tf
resource "aws_efs_file_system" "Wordpress-EFS" {
  creation_token   = "myefs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags = {
    Name = "${var.environment}-Wordpress-EFS"
  }
}

resource "aws_efs_mount_target" "main" {
  #  count = "${element(aws_subnet.public_subnet.*.id)}"
  count          = length(data.aws_availability_zones.available.names)
  file_system_id = aws_efs_file_system.Wordpress-EFS.id
#  subnet_id      = flatten(var.private_subnet_ids)[0]
#  subnet_id      = element(["var.private_subnet_ids"],1)
  subnet_id       = "${element(var.private_subnet_ids, count.index)}"
#  subnet_id = "module.vpc.aws_subnet.private_subnet[count.index].id"
  security_groups = [
    "${aws_security_group.efs.id}",
  ]
}


resource "aws_security_group" "efs" {
  name        = "efs-mnt"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = var.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "allow_nfs-ec2"
  }
}

output "efs-kamil" {
  description = "The DNS name of the load balancer."
  value       = aws_efs_file_system.Wordpress-EFS.id
}