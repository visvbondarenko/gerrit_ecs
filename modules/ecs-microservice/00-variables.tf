variable "account_shorthand"          {}
variable "environment"                {}
variable "project"                    {}
variable "service"                    {}
variable "owner"                      {}
variable "expiration_date"            {}
variable "monitor"                    {}
variable "cost_center"                {}

variable "cluster_name"               {}
variable "cluster_arn"                {}
variable "image"                      {}

variable "lb_target_group_arn"        {}

variable "service_cpu"                { default = "256" }
variable "service_memory"             { default = "256" }
variable "service_working_dir"        { default = "/application" }

variable "service_host_port"          {}
variable "service_container_port"     {}

variable "awslogs_group"              { default = "" }
variable "awslogs_region"             { default = "" }
variable "awslogs_stream_prefix"      { default = "" }
