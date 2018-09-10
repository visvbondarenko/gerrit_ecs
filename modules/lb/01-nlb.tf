resource "aws_lb" "lb" {
  name               = "${var.account_shorthand}-${var.environment}-${var.service}-NLB"
  load_balancer_type = "network"
  internal           = true

  subnets = [ "${var.subnet_ids}" ]
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.account_shorthand}-${var.environment}-${var.service}-TG"
  port     = "${var.target_port}"
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  target_type = "instance"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "${var.lb_port}"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.tg.arn}"
    type             = "forward"
  }
}
