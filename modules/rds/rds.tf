resource "aws_db_instance" "myrds" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  identifier             = "wordpress-rds"
  db_name                = var.database_name
  username               = var.database_username
  password               = var.database_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysubnet.name
  vpc_security_group_ids = [aws_security_group.rds-instance-sg.id]
}


resource "aws_db_subnet_group" "mysubnet" {
  name       = "main"
  subnet_ids =  var.private_subnet_ids
#  subnet_ids = flatten(["module.vpc.aws_subnet.private_subnet"])

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_security_group" "rds-instance-sg" {
  name        = "Allow db traffic"
  vpc_id      = var.vpc_id
  description = "Allow db inbound traffic"

  ingress {
    description = "Allow ssh from everywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #    cidr_blocks      = aws_vpc.vpc.cidr_block
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = [var.security_groups]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }

}

output "rds-endpoint" {
  value = aws_db_instance.myrds.address
}
