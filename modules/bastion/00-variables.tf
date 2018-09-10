variable "account_shorthand" {}
variable "environment"       {}
variable "project"           {}
variable "service"           {}
variable "owner"             {}
variable "expiration_date"   {}
variable "monitor"           {}
variable "cost_center"       {}
variable "base_ami" { default = "ami-0d907a0f49b3c1bf0" }
variable "vpc_id"  { default = "" }
variable "azs"     { default = [] }
variable "subnets" { default = [] }

variable "key_name" { default = "" }

variable "allowed_cidr"      { default = [ "0.0.0.0/0" ] }
variable "allowed_ipv6_cidr" { default = [ "::/0" ] }

#variable "ami_id"            { default = "ami-6944c513" }
variable "ami_id"            { default = "ami-04681a1dbd79675a5" }
variable "ami_owners"        { default = ["self", "amazon", "aws-marketplace"] }
variable "lookup_latest_ami" { default = false }

variable "instance_type" { default = "t2.micro" }

variable "tags" {
  type    = "map"
  default = {}
}

variable "public_ssh_keys" {
  type = "list"
  default = []
}

locals {
  local_tags = {
    Environment    = "${var.environment}"
    Project        = "${var.project}"
    Service        = "${var.service}"
    Owner          = "${var.owner}"
    ExpirationDate = "${var.expiration_date}"
    Monitor        = "${var.monitor}"
    CostCenter     = "${var.cost_center}"
    ManagedBy      = "Terraform"
  }

  tags = "${merge(local.local_tags, var.tags)}"
}
