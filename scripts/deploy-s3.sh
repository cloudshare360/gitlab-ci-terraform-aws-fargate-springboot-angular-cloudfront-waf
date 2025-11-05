# S3 Deployment script for Angular
#!/bin/bash

set -e

echo "Deploying Angular application to S3..."

# Get bucket name from Terraform output
S3_BUCKET=$(terraform output -raw s3_bucket_name)
CLOUDFRONT_DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)

echo "S3 Bucket: $S3_BUCKET"
echo "CloudFront Distribution: $CLOUDFRONT_DISTRIBUTION_ID"

# Navigate to build directory
cd frontend/dist/fargate-angular-frontend

# Sync files to S3 with appropriate cache headers
echo "Syncing files to S3..."

# Upload HTML files with no-cache headers
aws s3 sync . s3://$S3_BUCKET \
  --exclude "*" \
  --include "*.html" \
  --cache-control "no-cache, no-store, must-revalidate" \
  --metadata-directive REPLACE \
  --delete

# Upload CSS and JS files with long cache headers
aws s3 sync . s3://$S3_BUCKET \
  --exclude "*" \
  --include "*.css" \
  --include "*.js" \
  --cache-control "public, max-age=31536000, immutable" \
  --metadata-directive REPLACE

# Upload other static assets
aws s3 sync . s3://$S3_BUCKET \
  --exclude "*.html" \
  --exclude "*.css" \
  --exclude "*.js" \
  --cache-control "public, max-age=604800" \
  --metadata-directive REPLACE

# Set content encoding for compressed files
echo "Setting content encoding for compressed files..."
aws s3 cp . s3://$S3_BUCKET \
  --recursive \
  --exclude "*" \
  --include "*.gz" \
  --content-encoding gzip \
  --metadata-directive REPLACE

# Invalidate CloudFront cache
if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ] && [ "$CLOUDFRONT_DISTRIBUTION_ID" != "null" ]; then
  echo "Creating CloudFront invalidation..."
  aws cloudfront create-invalidation \
    --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
    --paths "/*"
  
  echo "Waiting for invalidation to complete..."
  aws cloudfront wait invalidation-completed \
    --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
    --id $(aws cloudfront list-invalidations --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --query 'InvalidationList.Items[0].Id' --output text)
fi

echo "S3 deployment completed successfully!"

# Display URLs
if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ] && [ "$CLOUDFRONT_DISTRIBUTION_ID" != "null" ]; then
  CLOUDFRONT_URL=$(terraform output -raw cloudfront_domain_name)
  echo "Application is available at: https://$CLOUDFRONT_URL"
else
  S3_WEBSITE_URL=$(terraform output -raw s3_website_endpoint)
  echo "Application is available at: http://$S3_WEBSITE_URL"
fi