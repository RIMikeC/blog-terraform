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
}

resource "aws_autoscaling_group" "asg" {
  name                 = "asg"
  launch_configuration = "${aws_launch_configuration.launch_config.name}"
  min_size             = 1
  max_size             = 2

  health_check_type   = "EC2"
  desired_capacity    = 1
  vpc_zone_identifier = ["${aws_subnet.subnets.*.id}"]

  #target_group_arns (Optional) A lilist of aws_alb_target_group ARNs, for use with Application Load Balancing.
#  target_group_arns    = ["${aws_lb_target_group.default.arn}", "${aws_lb_target_group.mgmt.arn}"]


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "alb" {
  name               = "blog-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.subnets.*.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "dev"
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

