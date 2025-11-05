output "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.arn
}

output "frontend_bucket_domain_name" {
  description = "Domain name of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.bucket_domain_name
}

output "frontend_website_endpoint" {
  description = "Website endpoint of the frontend S3 bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "frontend_website_domain" {
  description = "Website domain of the frontend S3 bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_domain
}

output "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
  value       = var.enable_logging ? aws_s3_bucket.logs[0].bucket : null
}

output "backend_assets_bucket_name" {
  description = "Name of the backend assets S3 bucket"
  value       = var.create_backend_bucket ? aws_s3_bucket.backend_assets[0].bucket : null
}

output "backend_assets_bucket_arn" {
  description = "ARN of the backend assets S3 bucket"
  value       = var.create_backend_bucket ? aws_s3_bucket.backend_assets[0].arn : null
}