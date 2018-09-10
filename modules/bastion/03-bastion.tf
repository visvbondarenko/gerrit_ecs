## Security
resource "aws_security_group" "bastion" {
  name   = "${var.account_shorthand}-${var.environment}-SG-BastionHost"
  vpc_id = "${var.vpc_id}"

  tags = "${local.tags}"
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = "${var.allowed_cidr}"
  ipv6_cidr_blocks  = "${var.allowed_ipv6_cidr}"
  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = [ "0.0.0.0/0" ]
  ipv6_cidr_blocks  = [ "::/0" ]
  security_group_id = "${aws_security_group.bastion.id}"
}

## LC and ASG
resource "aws_launch_configuration" "bastion" {
  name_prefix      = "${var.account_shorthand}-${var.environment}-LC-BastionHost"

  image_id             = "${var.base_ami}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"
  key_name             = "${var.key_name}"

  user_data        = "${data.template_file.user_data.rendered}"

  associate_public_ip_address = false # we'll use an EIP
  security_groups  = [ "${aws_security_group.bastion.id}" ]

  root_block_device {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/userdata/userdata.sh.tpl")}"

  vars {
    eip_id = "${aws_eip.bastion.id}"
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "${var.account_shorthand}-${var.environment}-ASG-BastionHost"
  launch_configuration = "${aws_launch_configuration.bastion.name}"

  vpc_zone_identifier = [ "${var.subnets}" ]

  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key                 = "Name",
      value               = "${var.account_shorthand}-${var.environment}-BastionHost"
      propagate_at_launch = true
    }
  ]

  tags = [ "${data.null_data_source.asg_common_tags.*.outputs}" ]

  lifecycle {
    create_before_destroy = true
  }
}

data "null_data_source" "asg_common_tags" {
  count = "${length(keys(local.tags))}"

  inputs = {
    key = "${element(keys(local.tags), count.index)}"
    value = "${element(values(local.tags), count.index)}"
    propagate_at_launch = true
  }
}

## EC2 policy
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.account_shorthand}-${var.environment}-BastionInstanceProfile"
  role = "${aws_iam_role.bastion_role.name}"
}

data "template_file" "bastion_assume_policy" {
  template = "${file("${path.module}/iam/bastion-assume-policy.json.tpl")}"
}

data "template_file" "bastion_policy" {
  template = "${file("${path.module}/iam/bastion-policy.json.tpl")}"

  vars {
    eip_id = "${aws_eip.bastion.id}"
  }
}

resource "aws_iam_role" "bastion_role" {
  name = "${var.account_shorthand}-${var.environment}-IAM_BastionRole"
  path = "/devops/"

  assume_role_policy = "${data.template_file.bastion_assume_policy.rendered}"
}

resource "aws_iam_role_policy" "bastion_policy" {
  name = "${var.account_shorthand}-${var.environment}-IAM-BastionRolePolicy"
  role = "${aws_iam_role.bastion_role.id}"

  policy = "${data.template_file.bastion_policy.rendered}"
}
