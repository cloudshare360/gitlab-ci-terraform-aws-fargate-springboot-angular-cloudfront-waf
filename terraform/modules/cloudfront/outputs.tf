output "s3_distribution_id" {
  description = "CloudFront S3 distribution ID"
  value       = var.enable_s3_distribution ? aws_cloudfront_distribution.s3_distribution[0].id : null
}

output "s3_distribution_domain_name" {
  description = "CloudFront S3 distribution domain name"
  value       = var.enable_s3_distribution ? aws_cloudfront_distribution.s3_distribution[0].domain_name : null
}

output "s3_distribution_hosted_zone_id" {
  description = "CloudFront S3 distribution hosted zone ID"
  value       = var.enable_s3_distribution ? aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id : null
}

output "alb_distribution_id" {
  description = "CloudFront ALB distribution ID"
  value       = var.enable_alb_distribution ? aws_cloudfront_distribution.alb_distribution[0].id : null
}

output "alb_distribution_domain_name" {
  description = "CloudFront ALB distribution domain name"
  value       = var.enable_alb_distribution ? aws_cloudfront_distribution.alb_distribution[0].domain_name : null
}

output "alb_distribution_hosted_zone_id" {
  description = "CloudFront ALB distribution hosted zone ID"
  value       = var.enable_alb_distribution ? aws_cloudfront_distribution.alb_distribution[0].hosted_zone_id : null
}

output "lambda_edge_function_arn" {
  description = "Lambda@Edge function ARN"
  value       = var.enable_s3_distribution ? aws_lambda_function.spa_router[0].qualified_arn : null
}