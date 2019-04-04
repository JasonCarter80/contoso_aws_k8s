module "vpc" {
  source = "git::ssh://git@github.com:JasonCarter80/aws_shared_vpc.git"

  ######################
  # Basics 
  ######################
  create_vpc                           = "${var.create_vpc}"
  name                                 = "${var.name}"
  cidr                                 = "${var.cidr}" 
  instance_tenancy                     = "${var.instance_tenancy}"


  subnets                              = "${var.subnets}"
  create_db_subnets                    = "${var.create_db_subnets}"
  create_elasticache_subnets           = "${var.create_elasticache_subnets}"
  flow_logs_bucket                     =  "${var.contoso-governance-logging-bucket}"
  
  ######################
  # Settings
  ######################
  enable_dns_hostnames                 = "${var.enable_dns_hostnames}"
  enable_dns_support                   = "${var.enable_dns_support}"
  enable_nat_gateway                   = "${var.enable_nat_gateway}"
  single_nat_gateway                   = "${var.single_nat_gateway}"
  one_nat_gateway_per_az               = "${var.one_nat_gateway_per_az}"
  reuse_nat_ips                        = "${var.reuse_nat_ips}"
  external_nat_ip_ids                  = "${var.external_nat_ip_ids}"
  enable_dynamodb_endpoint             = "${var.enable_dynamodb_endpoint}"
  enable_s3_endpoint                   = "${var.enable_s3_endpoint}"
  map_public_ip_on_launch              = "${var.map_public_ip_on_launch}"

  enable_dhcp_options                   = "${var.enable_dhcp_options}"
  dhcp_options_domain_name              = "${var.dhcp_options_domain_name}"
  dhcp_options_domain_name_servers      = "${var.dhcp_options_domain_name_servers}"
  dhcp_options_ntp_servers              = "${var.dhcp_options_ntp_servers}"
  dhcp_options_netbios_name_servers     = "${var.dhcp_options_netbios_name_servers}"
  dhcp_options_netbios_node_type        = "${var.dhcp_options_netbios_node_type}"
  
  
  ######################
  # Tagging
  ######################
  tags = "${merge(
      local.tags,
      map(
        "Name", "${var.name}-vpc",
        "tag_role", "vpc",
        
      )
    )}"
                   
}
