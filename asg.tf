# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical official

}

## Creating Launch Configuration
resource "aws_launch_configuration" "web" {
  image_id   = "ami-0bc543f54053e440b"
#kamil commited
#  image_id = data.aws_ami.ubuntu.id
  name     = "web_config"
  #  vpc_id      = aws_vpc.vpc.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ec2-instance-sg.id}"]
  key_name        = var.key_name
  user_data = templatefile("user_data.tfpl", { rds_endpoint = "${aws_db_instance.myrds.address}", user = var.database_username, password = var.database_password, dbname = var.database_name, efs = "${aws_efs_file_system.Wordpress-EFS.id}" })
  #  instance_initiated_shutdown_behavior = "terminate"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web" {
  depends_on = [
    aws_launch_configuration.web,
  ]
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.web.id
  force_delete         = true
  vpc_zone_identifier  = aws_subnet.public_subnet.*.id
  #  availability_zones   = var.availability_zones
  min_size         = 1
  max_size         = 2
  desired_capacity = 2
  #  target_group_arns = ["aws_lb_target_group.tg.arn"]
  #  target_group_arns = ["${var.target_group_arn}"]
  health_check_type = "ELB"
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web.id

  lb_target_group_arn = aws_lb_target_group.tg.arn
}

resource "aws_security_group" "ec2-instance-sg" {
  name        = "Allow web traffic"
  vpc_id      = aws_vpc.vpc.id
  description = "Allow Web inbound traffic"

  ingress {
    description      = "Allow ssh from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow http from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

