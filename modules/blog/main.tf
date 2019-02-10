data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami*_64-gp2"]
  }
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix          = "AWS_linux_2"
  image_id             = "${data.aws_ami.ami.id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name             = "${aws_key_pair.keys.key_name}"
  user_data            = "${file("${path.module}/startblog.sh")}"
  enable_monitoring    = true
  placement_tenancy    = "default"
  security_groups      = ["${aws_security_group.blog_ec2.id}"]

  lifecycle {
    create_before_destroy = true
  }
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
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }

  ingress {
    from_port   = 1313
    to_port     = 1313
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "hugo"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All TCP"
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

resource "aws_key_pair" "keys" {
  public_key = "${file("${path.module}/test230119.pub")}"
}
