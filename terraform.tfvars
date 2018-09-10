aws_region                 = "us-east-1"
account_shorthand          = "devqa"
environment                = "gerrit"
project                    = ""
service                    = "gerrit"
owner                      = "mike.mcclintock@thetrackr.com"
expiration_date            = "2018-12-31"
monitor                    = "0"
cost_center                = ""

vpc_cidr                   = "10.8.0.0/16"
vpc_azs                    = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
vpc_private_subnets        = [ "10.8.32.0/19", "10.8.96.0/19", "10.8.160.0/19" ]
vpc_public_subnets         = [ "10.8.0.0/22", "10.8.64.0/22", "10.8.128.0/22" ]

vpc_enable_dns_hostnames   = true
vpc_enable_nat_gateway     = true
vpc_single_nat_gateway     = false
vpc_one_nat_gateway_per_az = true

domain_hosted_zone   = "dev.aderoio.com."
dns_alias_jenkins    = "gerrit"
alb_ssl_cert_jenkins = "*.dev.aderoio.com"

tags = {}

ecs_instance_type = "t2.small"
ecs_enable_ssh    = true
ecs_min_size      = 1
ecs_desired_size  = 1
ecs_instance_root_size = 60
