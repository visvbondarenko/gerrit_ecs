data "aws_ami" "amazon_linux_ami" {
  count       = "${var.lookup_latest_ami ? 1 : 0}"
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-ebs"]
  }

  filter {
    name   = "owner-alias"
    values = ["${var.ami_owners}"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "user_ami" {
  count  = "${var.lookup_latest_ami ? 0 : 1}"
  owners = ["${var.ami_owners}"]

  filter {
    name   = "image-id"
    values = ["${var.ami_id}"]
  }
}

locals {
  # Using join() is a workaround for depending on conditional resources.
  # https://github.com/hashicorp/terraform/issues/2831#issuecomment-298751019
  ami_id = "${var.lookup_latest_ami ? join("", data.aws_ami.amazon_linux_ami.*.image_id) : join("", data.aws_ami.user_ami.*.image_id)}"
}
