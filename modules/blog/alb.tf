resource "aws_lb" "alb" {
  name               = "blog-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.subs.0.id}", "${aws_subnet.subs.1.id}", "${aws_subnet.subs.2.id}"]
  security_groups    = ["${aws_security_group.alb.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

resource "aws_security_group" "alb" {
  description = "Security group allowing traffic to the ALB"
  vpc_id      = "${aws_vpc.default.id}"
  name        = "blog_alb"
}

resource "aws_security_group_rule" "allow_web" {
  type        = "ingress"
  from_port   = 1313
  to_port     = 1313
  protocol    = "tcp"
  cidr_blocks = ["193.105.212.250/32", "80.168.1.186/32"]

  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_lb_target_group" "default" {
  name                 = "blog-target"
  port                 = 1313
  protocol             = "HTTP"
  deregistration_delay = 20
  vpc_id               = "${aws_vpc.default.id}"
  target_type          = "instance"

  #  health_check {
  #    healthy_threshold   = 4
  #    unhealthy_threshold = 3
  #    timeout             = 5
  #    port                = "traffic-port"
  #    path                = "/"
  #    interval            = 10
  #  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "1313"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.default.arn}"
  }
}
