data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami*_64-gp2"]
  }
}

resource "aws_launch_configuration" "launch_config" {
  name                 = "AWS_linux_2"
  image_id             = "${data.aws_ami.ami.id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name             = "${aws_key_pair.keys.key_name}"
  user_data            = "${file("${path.module}/startblog.sh")}"
  enable_monitoring    = true
  placement_tenancy    = "default"
  security_groups      = ["${aws_security_group.blog_ec2.id}"]
}

resource "aws_security_group" "blog_ec2" {
  name        = "allow_all_web"
  description = "Allow all web inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "asg"
  launch_configuration = "${aws_launch_configuration.launch_config.name}"
  min_size             = 1
  max_size             = 2

  health_check_type   = "EC2"
  desired_capacity    = 1
  vpc_zone_identifier = ["${aws_subnet.pubs.*.id}"]

  target_group_arns = ["${aws_lb_target_group.default.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "alb" {
  name               = "blog-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.pubs.*.id}"]
  security_groups    = ["${aws_security_group.alb.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

resource "aws_security_group" "alb" {
  description = "Security group allowing traffic to the sqlpad ELB"
  vpc_id      = "${aws_vpc.default.id}"

  tags {
    Name = "blog ALB sec"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "default" {
  name                 = "blog-target"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 20
  vpc_id               = "${aws_vpc.default.id}"
  target_type          = "instance"

  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 3
    timeout             = 5
    port                = "traffic-port"
    path                = "/"
    interval            = 10
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_key_pair" "keys" {
  public_key = "${file("${path.module}/test230119.pub")}"
}

# resource aws_instance "blog" {
#   ami                         = "${data.aws_ami.ami.id}"
#   instance_type               = "t2.micro"
#   subnet_id                   = "subnet-c0dc22a6"
#   associate_public_ip_address = "true"
#   tags                        = "${var.tags}"
#   key_name                    = "${aws_key_pair.keys.key_name}"
#   vpc_security_group_ids      = ["sg-0cb6af1b772ad904f"]
#   user_data                   = "${file("${path.module}/startblog.sh")}"
#   iam_instance_profile        = "${aws_iam_instance_profile.ec2_instance_profile.name}"
# 
#   lifecycle {
#     create_before_destroy = true
#   }
# }

