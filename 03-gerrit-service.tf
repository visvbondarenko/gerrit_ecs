module "gerrit-service" {
  source = "git@github.com:TrackRbyPhoneHalo/it-fs-terraform-mod-microservice-ecs.git?ref=gerrit"

  service           = "gerrit"
  account_shorthand = "${var.account_shorthand}"
  environment       = "${var.environment}"
  project           = "${var.project}"
  owner             = "${var.owner}"
  expiration_date   = "${var.expiration_date}"
  monitor           = "${var.monitor}"
  cost_center       = "${var.cost_center}"

  cluster_name = "${module.ecs.name}"
  cluster_arn  = "${module.ecs.arn}"

  image = "${lookup(data.external.cloud-entity-docker-image.result, "image", "")}:${lookup(data.external.cloud-entity-docker-image.result, "tag", "")}"
  lb_target_group_arn = "${aws_alb_target_group.gerrit_http.arn}"

  service_cpu    = "1024"
  service_memory = "2048"

  service_host_port      = 8080
  service_container_port = 8080
  migrate_host_port      = 8081
  migrate_container_port = 8081

}

data "aws_secretsmanager_secret" "gerrit_docker_image" {
  name = "${lower("${var.account_shorthand}/${var.environment}/gerrit/docker_image")}"
}

data "aws_secretsmanager_secret_version" "gerrit_docker_image" {
  secret_id = "${data.aws_secretsmanager_secret.gerrit_docker_image.id}"
}

data "external" "cloud-entity-docker-image" {
  program = [ "echo", "${data.aws_secretsmanager_secret_version.gerrit_docker_image.secret_string}" ]
}
