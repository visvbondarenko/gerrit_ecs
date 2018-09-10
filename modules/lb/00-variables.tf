variable "account_shorthand" {}
variable "environment"       {}
variable "project"           {}
variable "service"           {}
variable "owner"             {}
variable "expiration_date"   {}
variable "monitor"           {}
variable "cost_center"       {}

variable "vpc_id"            {}
variable "subnet_ids"        { type = "list" }

variable "lb_port"           {}
variable "target_port"       {}
