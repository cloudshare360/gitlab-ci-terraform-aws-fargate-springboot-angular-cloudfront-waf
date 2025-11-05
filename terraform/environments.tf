# Call VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
}

# Call Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
}

# Call ALB Module
module "alb" {
  source = "./modules/alb"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
  certificate_arn   = var.certificate_arn
}

# Call ECR Module
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# Call RDS Module
module "rds" {
  source = "./modules/rds"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                   = module.vpc.vpc_id
  database_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_id        = module.security_groups.rds_security_group_id
  db_username              = var.db_username
  db_password              = var.db_password
}

# Call ECS Backend Module
module "ecs_backend" {
  source = "./modules/ecs"

  project_name         = var.project_name
  environment          = var.environment
  service_name         = "backend"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.security_groups.ecs_security_group_id
  target_group_arn    = module.alb.backend_target_group_arn
  image_uri           = var.backend_image_uri
  container_port      = 8080
  container_cpu       = var.container_cpu
  container_memory    = var.container_memory
  desired_count       = var.backend_desired_count
  
  environment_variables = [
    {
      name  = "DB_URL"
      value = "jdbc:mysql://${module.rds.endpoint}:${module.rds.port}/fargatedb"
    },
    {
      name  = "DB_USERNAME"
      value = var.db_username
    },
    {
      name  = "DB_PASSWORD"
      value = var.db_password
    },
    {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  ]
}

# Call S3 Module
module "s3" {
  source = "./modules/s3"

  project_name           = var.project_name
  environment            = var.environment
  api_domain_name        = module.alb.dns_name
  enable_logging         = true
  create_backend_bucket  = true
}

# Call ECS Frontend Module (Conditional)
module "ecs_frontend" {
  count  = var.frontend_deployment_mode == "fargate" ? 1 : 0
  source = "./modules/ecs"

  project_name         = var.project_name
  environment          = var.environment
  service_name         = "frontend"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.security_groups.ecs_security_group_id
  target_group_arn    = module.alb.frontend_target_group_arn
  image_uri           = var.frontend_image_uri
  container_port      = 80
  container_cpu       = var.container_cpu
  container_memory    = var.container_memory
  desired_count       = var.frontend_desired_count
  
  environment_variables = [
    {
      name  = "API_URL"
      value = "https://${module.alb.dns_name}"
    }
  ]
}

# Call CloudFront Module (Updated)
module "cloudfront" {
  count  = var.enable_cloudfront ? 1 : 0
  source = "./modules/cloudfront"

  project_name               = var.project_name
  environment                = var.environment
  enable_s3_distribution     = var.frontend_deployment_mode == "s3"
  enable_alb_distribution    = var.frontend_deployment_mode == "fargate"
  s3_bucket_name            = module.s3.frontend_bucket_name
  s3_bucket_domain_name     = module.s3.frontend_bucket_domain_name
  alb_dns_name              = module.alb.dns_name
  certificate_arn           = var.certificate_arn
  domain_name               = var.domain_name
  waf_web_acl_id            = var.enable_waf ? module.waf[0].web_acl_id : null
  price_class               = var.cloudfront_price_class
}

# Call WAF Module (Optional)
module "waf" {
  count  = var.enable_waf ? 1 : 0
  source = "./modules/waf"

  project_name = var.project_name
  environment  = var.environment
}