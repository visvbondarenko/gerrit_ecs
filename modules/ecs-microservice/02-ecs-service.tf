#resource "aws_ecs_service" "microservice" {
#  name            = "${var.account_shorthand}-${var.environment}-${var.service}-Service"
#  cluster         = "${var.cluster_arn}"
#  task_definition = "${aws_ecs_task_definition.microservice.arn}"
#  launch_type     = "EC2"
#  desired_count   = 1
#
#  load_balancer {
#    target_group_arn = "${var.lb_target_group_arn}"
#    container_name   = "${var.service}" # must match with container name in container definition
#    container_port   = "${var.service_container_port}"
#  }
#
#  deployment_minimum_healthy_percent = 50
#  deployment_maximum_percent         = 200
#
#  placement_constraints {
#    type = "distinctInstance"
#  }
#
#  ordered_placement_strategy {
#    type  = "spread"
#    field = "host"
#  }

#  lifecycle {
#    ignore_changes = [ "desired_count" ]
#  }
#}
