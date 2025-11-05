# S3 Build and Deploy script for Angular
#!/bin/bash

set -e

echo "Building Angular application for S3 deployment..."

# Navigate to frontend directory
cd frontend

# Install dependencies
echo "Installing dependencies..."
npm ci --production

# Build for production with S3 optimizations
echo "Building for production..."
npm run build:prod

# Configure environment for production
echo "Configuring production environment..."
cat > dist/fargate-angular-frontend/assets/config.json << EOF
{
  "apiUrl": "https://${ALB_DNS_NAME}",
  "environment": "${CI_ENVIRONMENT_NAME}",
  "version": "${CI_COMMIT_SHA}",
  "buildTime": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)"
}
EOF

# Optimize files for S3
echo "Optimizing files for S3..."

# Set proper MIME types and caching headers
find dist/fargate-angular-frontend -name "*.js" -exec gzip -9 -c {} \; > {}.gz
find dist/fargate-angular-frontend -name "*.css" -exec gzip -9 -c {} \; > {}.gz
find dist/fargate-angular-frontend -name "*.html" -exec gzip -9 -c {} \; > {}.gz

echo "Build completed successfully!"
echo "Built files are ready for S3 deployment in: dist/fargate-angular-frontend/"