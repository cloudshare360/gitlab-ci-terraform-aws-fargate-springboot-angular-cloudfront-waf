variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "fargate-springboot-angular"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "SSL certificate ARN for CloudFront"
  type        = string
  default     = ""
}

variable "backend_image_uri" {
  description = "ECR URI for backend container image"
  type        = string
  default     = ""
}

variable "frontend_image_uri" {
  description = "ECR URI for frontend container image"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "container_cpu" {
  description = "CPU units for containers"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Memory for containers"
  type        = number
  default     = 1024
}

variable "backend_desired_count" {
  description = "Desired number of backend tasks"
  type        = number
  default     = 2
}

variable "frontend_desired_count" {
  description = "Desired number of frontend tasks"
  type        = number
  default     = 2
}

variable "enable_waf" {
  description = "Enable WAF protection"
  type        = bool
  default     = true
}

variable "enable_cloudfront" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = true
}

variable "frontend_deployment_mode" {
  description = "Frontend deployment mode: 'fargate' or 's3'"
  type        = string
  default     = "fargate"
  validation {
    condition     = contains(["fargate", "s3"], var.frontend_deployment_mode)
    error_message = "Frontend deployment mode must be either 'fargate' or 's3'."
  }
}

variable "enable_s3_frontend" {
  description = "Enable S3 static website hosting for frontend"
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}