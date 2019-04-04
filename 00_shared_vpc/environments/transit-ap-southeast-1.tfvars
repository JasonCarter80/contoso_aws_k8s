cidr = "10.1.0.0/16"

name = "shared"

aws_region = "ap-southeast-1"

enable_dns_hostnames = true

create_db_subnets     = true
create_elasticache_subnets = true

dhcp_options_domain_name    = "internal-domain.com"

enable_nat_gateway          = true 
single_nat_gateway          = false 
enable_vpn_gateway          = false 

## Tags
tag_productcode = "contoso-INFRA"
tag_owner = "vp@company.com"
tag_responsible = "ops-team@company.com"
tag_role = "Production Shared VPC"


subnets = ["transit", "prod", "dev" , "demo"  ]

