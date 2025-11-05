output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.zone_id
}

output "backend_cluster_name" {
  description = "Name of the backend ECS cluster"
  value       = module.ecs_backend.cluster_name
}

output "frontend_cluster_name" {
  description = "Name of the frontend ECS cluster"
  value       = var.frontend_deployment_mode == "fargate" ? module.ecs_frontend[0].cluster_name : null
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.port
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for frontend assets"
  value       = module.s3.frontend_bucket_name
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = module.s3.frontend_website_endpoint
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = var.enable_cloudfront ? (var.frontend_deployment_mode == "s3" ? module.cloudfront[0].s3_distribution_id : module.cloudfront[0].alb_distribution_id) : null
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = var.enable_cloudfront ? (var.frontend_deployment_mode == "s3" ? module.cloudfront[0].s3_distribution_domain_name : module.cloudfront[0].alb_distribution_domain_name) : null
}

output "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  value       = var.enable_waf ? module.waf[0].web_acl_id : null
}

output "ecr_backend_repository_url" {
  description = "ECR repository URL for backend"
  value       = module.ecr.backend_repository_url
}

output "ecr_frontend_repository_url" {
  description = "ECR repository URL for frontend"
  value       = module.ecr.frontend_repository_url
}

output "backend_task_definition_arn" {
  description = "ARN of the backend task definition"
  value       = module.ecs_backend.task_definition_arn
}

output "frontend_task_definition_arn" {
  description = "ARN of the frontend task definition"
  value       = var.frontend_deployment_mode == "fargate" ? module.ecs_frontend[0].task_definition_arn : null
}

output "api_endpoint" {
  description = "API endpoint URL"
  value       = "https://${module.alb.dns_name}/api"
}

output "frontend_url" {
  description = "Frontend application URL"
  value       = var.enable_cloudfront ? "https://${var.frontend_deployment_mode == "s3" ? module.cloudfront[0].s3_distribution_domain_name : module.cloudfront[0].alb_distribution_domain_name}" : (var.frontend_deployment_mode == "s3" ? "http://${module.s3.frontend_website_endpoint}" : "https://${module.alb.dns_name}")
}

output "deployment_mode" {
  description = "Frontend deployment mode"
  value       = var.frontend_deployment_mode
}