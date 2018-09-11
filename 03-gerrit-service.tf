module "gerrit-lb" {
  source = "./modules/lb"

  service           = "gerrit"
  account_shorthand = "${var.account_shorthand}"
  environment       = "${var.environment}"
  project           = "${var.project}"
  owner             = "${var.owner}"
  expiration_date   = "${var.expiration_date}"
  monitor           = "${var.monitor}"
  cost_center       = "${var.cost_center}"

  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnets}"

  lb_port     = 8080
  target_port = 8080
}

module "gerrit-service" {
  source = "./modules/ecs-microservice"

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
  lb_target_group_arn = "${module.gerrit-lb.lb_target_group_arn}"

  service_cpu    = "256"
  service_memory = "256"

  service_host_port      = 8080
  service_container_port = 8080
}

data "aws_secretsmanager_secret" "gerrit" {
  name = "${lower("${var.account_shorthand}/${var.environment}/${var.service}/docker_image")}"
}

data "aws_secretsmanager_secret_version" "gerrit" {
  secret_id = "${data.aws_secretsmanager_secret.gerrit.id}"
}

data "external" "cloud-entity-docker-image" {
  program = [ "echo", "${data.aws_secretsmanager_secret_version.gerrit.secret_string}" ]
}
