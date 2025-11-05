variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_s3_distribution" {
  description = "Enable CloudFront distribution for S3"
  type        = bool
  default     = true
}

variable "enable_alb_distribution" {
  description = "Enable CloudFront distribution for ALB"
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = ""
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
  default     = ""
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
  default     = ""
}

variable "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}