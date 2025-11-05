# CloudFront Origin Access Control for S3
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  count                             = var.enable_s3_distribution ? 1 : 0
  name                              = "${var.project_name}-${var.environment}-s3-oac"
  description                       = "OAC for S3 bucket access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution for S3 Frontend
resource "aws_cloudfront_distribution" "s3_distribution" {
  count = var.enable_s3_distribution ? 1 : 0

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac[0].id
    origin_id                = "S3-${var.s3_bucket_name}"
  }

  # API Backend Origin
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "ALB-Backend"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name} ${var.environment} - Frontend and API Distribution"
  default_root_object = "index.html"

  # Aliases
  aliases = var.domain_name != "" ? [var.domain_name] : []

  # Default cache behavior for S3 (Frontend)
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    # Lambda@Edge function for SPA routing
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.spa_router[0].qualified_arn
      include_body = false
    }
  }

  # Cache behavior for API endpoints
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "ALB-Backend"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  # Cache behavior for static assets
  ordered_cache_behavior {
    path_pattern           = "*.js"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 31536000  # 1 year
    default_ttl = 31536000
    max_ttl     = 31536000
  }

  ordered_cache_behavior {
    path_pattern           = "*.css"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 31536000  # 1 year
    default_ttl = 31536000
    max_ttl     = 31536000
  }

  # Price class
  price_class = var.price_class

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL Certificate
  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == "" ? true : false
    acm_certificate_arn           = var.certificate_arn != "" ? var.certificate_arn : null
    ssl_support_method            = var.certificate_arn != "" ? "sni-only" : null
    minimum_protocol_version      = var.certificate_arn != "" ? "TLSv1.2_2021" : null
  }

  # WAF Association
  web_acl_id = var.waf_web_acl_id

  # Custom Error Pages
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cloudfront-s3"
    Environment = var.environment
    Type        = "S3-Distribution"
  }
}

# CloudFront Distribution for ALB (Alternative deployment)
resource "aws_cloudfront_distribution" "alb_distribution" {
  count = var.enable_alb_distribution ? 1 : 0

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "ALB-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.project_name} ${var.environment} - ALB Distribution"

  aliases = var.domain_name != "" ? ["api.${var.domain_name}"] : []

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "ALB-Origin"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == "" ? true : false
    acm_certificate_arn           = var.certificate_arn != "" ? var.certificate_arn : null
    ssl_support_method            = var.certificate_arn != "" ? "sni-only" : null
    minimum_protocol_version      = var.certificate_arn != "" ? "TLSv1.2_2021" : null
  }

  web_acl_id = var.waf_web_acl_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-cloudfront-alb"
    Environment = var.environment
    Type        = "ALB-Distribution"
  }
}

# Lambda@Edge function for SPA routing
resource "aws_lambda_function" "spa_router" {
  count = var.enable_s3_distribution ? 1 : 0

  filename         = "spa-router.zip"
  function_name    = "${var.project_name}-${var.environment}-spa-router"
  role            = aws_iam_role.lambda_edge[0].arn
  handler         = "index.handler"
  source_code_hash = data.archive_file.spa_router_zip[0].output_base64sha256
  runtime         = "nodejs18.x"
  publish         = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-spa-router"
    Environment = var.environment
  }
}

# Archive file for Lambda function
data "archive_file" "spa_router_zip" {
  count = var.enable_s3_distribution ? 1 : 0

  type        = "zip"
  output_path = "spa-router.zip"
  source {
    content = file("${path.module}/spa-router.js")
    filename = "index.js"
  }
}

# IAM role for Lambda@Edge
resource "aws_iam_role" "lambda_edge" {
  count = var.enable_s3_distribution ? 1 : 0
  name  = "${var.project_name}-${var.environment}-lambda-edge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
      }
    ]
  })
}

# IAM policy attachment for Lambda@Edge
resource "aws_iam_role_policy_attachment" "lambda_edge" {
  count = var.enable_s3_distribution ? 1 : 0

  role       = aws_iam_role.lambda_edge[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}