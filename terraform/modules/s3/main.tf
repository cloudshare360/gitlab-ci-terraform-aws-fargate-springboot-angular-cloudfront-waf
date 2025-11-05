# S3 Bucket for Frontend Static Website Hosting
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${var.environment}-frontend-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Environment = var.environment
    Purpose     = "Frontend Static Website"
  }
}

# Random string for bucket naming
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"  # Angular SPA routing
  }

  routing_rule {
    condition {
      key_prefix_equals = "api/"
    }
    redirect {
      host_name          = var.api_domain_name
      http_redirect_code = "301"
      protocol           = "https"
    }
  }
}

# S3 Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# S3 Bucket CORS Configuration
resource "aws_s3_bucket_cors_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    id     = "delete_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Logging (Optional)
resource "aws_s3_bucket" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = "${var.project_name}-${var.environment}-frontend-logs-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend-logs"
    Environment = var.environment
    Purpose     = "Access Logs"
  }
}

resource "aws_s3_bucket_logging" "frontend" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.frontend.id

  target_bucket = aws_s3_bucket.logs[0].id
  target_prefix = "access-logs/"
}

# S3 Bucket for Backend Assets (Optional)
resource "aws_s3_bucket" "backend_assets" {
  count  = var.create_backend_bucket ? 1 : 0
  bucket = "${var.project_name}-${var.environment}-backend-assets-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-assets"
    Environment = var.environment
    Purpose     = "Backend File Storage"
  }
}

resource "aws_s3_bucket_versioning" "backend_assets" {
  count  = var.create_backend_bucket ? 1 : 0
  bucket = aws_s3_bucket.backend_assets[0].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_assets" {
  count  = var.create_backend_bucket ? 1 : 0
  bucket = aws_s3_bucket.backend_assets[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block for Backend Assets
resource "aws_s3_bucket_public_access_block" "backend_assets" {
  count  = var.create_backend_bucket ? 1 : 0
  bucket = aws_s3_bucket.backend_assets[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}