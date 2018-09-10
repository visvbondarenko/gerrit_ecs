## Service autoscaling
#resource "aws_iam_role" "autoscaling_role" {
#  name = "${var.account_shorthand}-${var.environment}-${var.service}-EcsAutoscalingRole"
#
#  assume_role_policy = "${data.template_file.autoscaling_assume_policy.rendered}"
#}
#
#resource "aws_iam_role_policy_attachment" "autoscaling_policy" {
#  role       = "${aws_iam_role.autoscaling_role.name}"
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole" # pre-canned policy by Amazon
#}
#
#data "template_file" "autoscaling_assume_policy" {
#  template = "${file("${path.module}/iam/ecs_autoscaling_assume_policy.json")}"
#}
#
#data "aws_caller_identity" "current" {}
#
#resource "aws_appautoscaling_target" "service" {
#  max_capacity        = 10
#  min_capacity        = 1
#  resource_id         = "service/${var.cluster_name}/${aws_ecs_service.microservice.name}"
##  role_arn            = "${aws_iam_role.autoscaling_role.arn}"
#  role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
#  scalable_dimension  = "ecs:service:DesiredCount"
#  service_namespace   = "ecs"
#}
#
#resource "aws_appautoscaling_policy" "scale_up" {
#  name               = "${var.account_shorthand}-${var.environment}-${var.service}-ScalingPolicyContainerScaleUp"
#  policy_type        = "StepScaling"
#  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.microservice.name}"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace  = "ecs"
#
#  step_scaling_policy_configuration {
#    adjustment_type         = "ChangeInCapacity"
#    cooldown                = 60
#    metric_aggregation_type = "Maximum"
#
#    step_adjustment {
#      metric_interval_upper_bound = 0
#      scaling_adjustment          = -1
#    }
#  }
#
#  depends_on = [ "aws_appautoscaling_target.service" ]
#}
#
#resource "aws_appautoscaling_policy" "scale_down" {
#  name               = "${var.account_shorthand}-${var.environment}-${var.service}-ScalingPolicyContainerScaleDown"
#  policy_type        = "StepScaling"
#  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.microservice.name}"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace  = "ecs"
#
#  step_scaling_policy_configuration {
#    adjustment_type         = "ChangeInCapacity"
#    cooldown                = 60
#    metric_aggregation_type = "Maximum"
#
#    step_adjustment {
#      metric_interval_upper_bound = 0
#      scaling_adjustment          = -1
#    }
#  }
#
#  depends_on = [ "aws_appautoscaling_target.service" ]
#}
#
#resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
#  alarm_name          = "${var.account_shorthand}-${var.environment}-${var.service}-CpuUtilizationHigh"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/ECS"
#  period              = "60"
#  statistic           = "Average"
#  threshold           = "85"
#
#  dimensions {
#    ClusterName = "${var.cluster_name}"
#    ServiceName = "${aws_ecs_service.microservice.name}"
#  }
#
#  alarm_actions = [ "${aws_appautoscaling_policy.scale_up.arn}" ]
#}
#
#resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
#  alarm_name          = "${var.account_shorthand}-${var.environment}-${var.service}-CpuUtilizationLow"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/ECS"
#  period              = "60"
#  statistic           = "Average"
#  threshold           = "10"
#
#  dimensions {
#    ClusterName = "${var.cluster_name}"
#    ServiceName = "${aws_ecs_service.microservice.name}"
#  }
#
#  alarm_actions = [ "${aws_appautoscaling_policy.scale_down.arn}" ]
#}
#
#resource "aws_cloudwatch_metric_alarm" "service_memory_high" {
#  alarm_name          = "${var.account_shorthand}-${var.environment}-${var.service}-MemoryUtilizationHigh"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "MemoryUtilization"
#  namespace           = "AWS/ECS"
#  period              = "60"
#  statistic           = "Average"
#  threshold           = "85"
#
#  dimensions {
#    ClusterName = "${var.cluster_name}"
#    ServiceName = "${aws_ecs_service.microservice.name}"
#  }
#
#  alarm_actions = [ "${aws_appautoscaling_policy.scale_up.arn}" ]
#}
#
#resource "aws_cloudwatch_metric_alarm" "service_memory_low" {
#  alarm_name          = "${var.account_shorthand}-${var.environment}-${var.service}-MemoryUtilizationLow"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "MemoryUtilization"
#  namespace           = "AWS/ECS"
#  period              = "60"
#  statistic           = "Average"
#  threshold           = "10"
#
#  dimensions {
#    ClusterName = "${var.cluster_name}"
#    ServiceName = "${aws_ecs_service.microservice.name}"
#  }
#
#  alarm_actions = [ "${aws_appautoscaling_policy.scale_down.arn}" ]
#}
