#VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "CIDR Block of VPC"
  value       = "${module.vpc.vpc_cidr_block}"
}

# Subnets

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = ["${module.vpc.database_subnets}"]
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = ["${module.vpc.elasticache_subnets}"]
}

output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = ["${module.vpc.redshift_subnets}"]
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = ["${module.vpc.intra_subnets}"]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = ["${module.vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = ["${module.vpc.private_route_table_ids}"]
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = ["${module.vpc.intra_route_table_ids}"]
}

output "tags" {
  value = "${local.tags}"
}
