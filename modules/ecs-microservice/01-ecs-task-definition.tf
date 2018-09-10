data "aws_region" "current" {}

# Microservice task definition
resource "aws_ecs_task_definition" "microservice" {
  family = "${var.account_shorthand}-${var.environment}-${var.service}-MicroserviceTask"

  task_role_arn      = "${aws_iam_role.ecs_task_role.arn}"
  execution_role_arn = "${aws_iam_role.ecs_task_role.arn}"

  network_mode = "host"
  cpu          = "${var.service_cpu}"
  memory       = "${var.service_memory}"

  requires_compatibilities = [ "EC2" ]

  container_definitions = "${data.template_file.microservice_container_definitions.rendered}"
}

resource "null_resource" "test_template" {
  triggers = {
    json = "${data.template_file.microservice_container_definitions.rendered}"
  }
}

data "template_file" "microservice_container_definitions" {
  template = "${file("${path.module}/task-definitions/microservice-container-definitions.json")}"

  vars {
    # general
    name                       = "${var.service}"
    image                      = "${var.image}"

    working_directory          = "${var.service_working_dir}"

    cpu                        = "${var.service_cpu}"

    # ports
    service_host_port          = "${var.service_host_port}"
    service_container_port     = "${var.service_container_port}"

    # logging
    awslogs_group              = "${var.awslogs_group == "" ? "/ecs/${var.environment}-${var.service}" : var.awslogs_group}"
    awslogs_region             = "${var.awslogs_region == "" ? data.aws_region.current.name : var.awslogs_region}"
    awslogs_stream_prefix      = "${var.awslogs_stream_prefix == "" ? "ecs" : var.awslogs_stream_prefix}"

  }
}

# IAM roles
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.account_shorthand}-${var.environment}-${var.service}-EcsTaskExecutionRole"

  assume_role_policy = "${data.template_file.ecs_task_assume_role.rendered}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = "${aws_iam_role.ecs_task_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "template_file" "ecs_task_assume_role" {
  template = "${file("${path.module}/iam/ecs_task_assume_role.json")}"
}
