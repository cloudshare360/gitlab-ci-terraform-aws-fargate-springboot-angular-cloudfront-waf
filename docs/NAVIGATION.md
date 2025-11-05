# 📁 Project Navigation & Documentation Index

## 🏠 Quick Navigation

### 📚 **Core Documentation**
- **[🚀 README.md](./README.md)** - Quick start guide and project overview
- **[🏗️ ARCHITECTURE.md](./ARCHITECTURE.md)** - Complete architecture documentation with hierarchical navigation
- **[📋 requirements.md](./requirements.md)** - Original project requirements

### 🔧 **Technical Documentation**

#### 📖 **Architecture & Design**
- [🏗️ System Architecture](./ARCHITECTURE.md#system-architecture) - High-level design and AWS infrastructure
- [🚀 Deployment Architectures](./ARCHITECTURE.md#deployment-architectures) - Fargate vs S3 deployment modes
- [🔐 Security Architecture](./ARCHITECTURE.md#security-architecture) - Multi-layer security design

#### 🔄 **CI/CD & DevOps**
- [🔄 CI/CD Pipeline](./ARCHITECTURE.md#cicd-pipeline) - Complete pipeline documentation
- [🏗️ Infrastructure as Code](./ARCHITECTURE.md#infrastructure-as-code) - Terraform modules and structure
- [🎯 Deployment Guide](./ARCHITECTURE.md#deployment-guide) - Step-by-step deployment instructions

#### 💻 **Application Architecture**
- [💻 Backend Architecture](./ARCHITECTURE.md#backend-architecture) - Spring Boot design patterns
- [🅰️ Frontend Architecture](./ARCHITECTURE.md#frontend-architecture) - Angular application structure
- [🗄️ Database Design](./ARCHITECTURE.md#database-design) - Database schema and relationships

#### 📊 **Operations & Monitoring**
- [📊 Monitoring & Observability](./ARCHITECTURE.md#monitoring-and-observability) - Complete monitoring strategy
- [🔐 Security Implementation](./ARCHITECTURE.md#security-implementation) - Security controls and measures
- [📁 Project Structure](./ARCHITECTURE.md#project-structure) - Repository organization

### 💻 **Source Code Navigation**

#### ☕ **Backend (Spring Boot)**
```
📁 backend/
├── 📄 Dockerfile                     # Container configuration
├── 📄 pom.xml                        # Maven dependencies
├── 📁 src/main/java/com/example/demo/
│   ├── 📄 DemoApplication.java       # Main application
│   ├── 📁 controller/                # REST controllers
│   │   └── 📄 UserController.java    # User CRUD operations
│   ├── 📁 service/                   # Business logic
│   │   └── 📄 UserService.java       # User service layer
│   ├── 📁 repository/                # Data access
│   │   └── 📄 UserRepository.java    # JPA repository
│   ├── 📁 model/                     # Entity models
│   │   └── 📄 User.java              # User entity
│   └── 📁 config/                    # Configuration
│       ├── 📄 SecurityConfig.java    # Security configuration
│       └── 📄 WebConfig.java         # Web configuration
└── 📁 src/main/resources/
    ├── 📄 application.yml            # Application properties
    └── 📄 application-prod.yml       # Production properties
```

#### 🅰️ **Frontend (Angular)**
```
📁 frontend/
├── 📄 Dockerfile                     # Container configuration
├── 📄 package.json                   # NPM dependencies
├── 📄 angular.json                   # Angular CLI configuration
├── 📁 src/
│   ├── 📄 main.ts                    # Application bootstrap
│   ├── 📁 app/
│   │   ├── 📄 app.component.ts       # Root component
│   │   ├── 📄 app.routes.ts          # Routing configuration
│   │   ├── 📁 components/            # Feature components
│   │   │   ├── 📄 user-list.component.ts    # User list view
│   │   │   ├── 📄 user-form.component.ts    # User form
│   │   │   └── 📄 navigation.component.ts   # Navigation bar
│   │   ├── 📁 services/              # Angular services
│   │   │   ├── 📄 user.service.ts    # User API service
│   │   │   └── 📄 auth.service.ts    # Authentication service
│   │   ├── 📁 models/                # TypeScript models
│   │   │   └── 📄 user.model.ts      # User interface
│   │   └── 📁 guards/                # Route guards
│   │       └── 📄 auth.guard.ts      # Authentication guard
│   └── 📁 environments/              # Environment configs
│       ├── 📄 environment.ts         # Development config
│       └── 📄 environment.prod.ts    # Production config
└── 📄 nginx.conf                     # Nginx configuration
```

#### 🏗️ **Infrastructure (Terraform)**
```
📁 terraform/
├── 📄 main.tf                        # Main configuration
├── 📄 variables.tf                   # Input variables
├── 📄 outputs.tf                     # Output values
├── 📄 environments.tf                # Environment-specific configs
├── 📄 terraform.tfvars.example       # Example variables
└── 📁 modules/                       # Reusable modules
    ├── 📁 vpc/                       # Network infrastructure
    │   ├── 📄 main.tf                # VPC, subnets, gateways
    │   ├── 📄 variables.tf           # VPC variables
    │   └── 📄 outputs.tf             # VPC outputs
    ├── 📁 ecs/                       # Container services
    │   ├── 📄 main.tf                # ECS cluster, services
    │   ├── 📄 variables.tf           # ECS variables
    │   ├── 📄 outputs.tf             # ECS outputs
    │   └── 📁 task-definitions/      # Task definition templates
    ├── 📁 rds/                       # Database
    │   ├── 📄 main.tf                # RDS instance
    │   ├── 📄 variables.tf           # Database variables
    │   └── 📄 outputs.tf             # Database outputs
    ├── 📁 alb/                       # Load balancer
    │   ├── 📄 main.tf                # ALB, target groups
    │   ├── 📄 variables.tf           # ALB variables
    │   └── 📄 outputs.tf             # ALB outputs
    ├── 📁 s3/                        # Static hosting (NEW)
    │   ├── 📄 main.tf                # S3 bucket, policies
    │   ├── 📄 variables.tf           # S3 variables
    │   └── 📄 outputs.tf             # S3 outputs
    ├── 📁 cloudfront/                # CDN (ENHANCED)
    │   ├── 📄 main.tf                # CloudFront distribution
    │   ├── 📄 variables.tf           # CloudFront variables
    │   ├── 📄 outputs.tf             # CloudFront outputs
    │   └── 📁 lambda/                # Lambda@Edge functions
    │       └── 📄 spa-routing.js     # SPA routing support
    └── 📁 waf/                       # Web application firewall
        ├── 📄 main.tf                # WAF rules, ACLs
        ├── 📄 variables.tf           # WAF variables
        └── 📄 outputs.tf             # WAF outputs
```

### 🔧 **DevOps & Automation**

#### 🔄 **CI/CD Pipeline**
- **[📄 .gitlab-ci.yml](./.gitlab-ci.yml)** - Complete CI/CD pipeline configuration
- **[📁 scripts/](./scripts/)** - Deployment and utility scripts
  - **[🚀 deploy.sh](./scripts/deploy.sh)** - Main deployment script
  - **[✅ health-check.sh](./scripts/health-check.sh)** - Health check utilities
  - **[📦 s3-deploy.sh](./scripts/s3-deploy.sh)** - S3 deployment script
  - **[🔧 setup-env.sh](./scripts/setup-env.sh)** - Environment setup

#### 📊 **Pipeline Stages**
1. **🔍 Validation** - Terraform format, validation, linting
2. **🏗️ Build** - Maven build, Angular build, Docker images
3. **🧪 Test** - Unit tests, integration tests, E2E tests
4. **🔒 Security** - SAST scanning, container scanning, dependency checks
5. **🚀 Deploy** - Infrastructure deployment + application deployment
6. **✅ Verify** - Health checks, smoke tests, monitoring setup

### 🌟 **New Features & Enhancements**

#### 🆕 **Dual Deployment Modes**
- **🚢 Container Mode**: Angular served via nginx containers on ECS Fargate
- **📦 S3 Static Mode**: Angular served as static files with CloudFront CDN
- **🔄 Configurable**: Switch between modes via `FRONTEND_DEPLOYMENT_MODE` variable

#### 🆕 **Enhanced Infrastructure**
- **⚡ Lambda@Edge**: SPA routing support for S3 deployments
- **🚀 CloudFront**: Enhanced with dual origin support (ALB + S3)
- **🔒 WAF**: Comprehensive OWASP Top 10 protection
- **📊 Monitoring**: Complete observability with CloudWatch

#### 🆕 **Documentation Improvements**
- **🏗️ Architecture Documentation**: Comprehensive technical guide with mermaid diagrams
- **🗺️ Hierarchical Navigation**: This document for easy navigation
- **📋 Detailed Diagrams**: System architecture, security, CI/CD flows
- **🎯 Deployment Guide**: Step-by-step instructions for all scenarios

### 🎯 **Getting Started Guide**

#### 1. **Quick Start** (5 minutes)
```bash
# Clone and configure
git clone <repo-url>
cd gitlab-ci-terraform-aws-fargate-springboot-angular-cloudfront-waf
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars with your values
```

#### 2. **Configuration** (10 minutes)
- Set GitLab CI/CD variables (AWS credentials, deployment mode)
- Configure Terraform variables in `terraform.tfvars`
- Review and customize application configurations

#### 3. **Deployment** (15-30 minutes)
```bash
# Deploy everything
git add . && git commit -m "Initial deployment" && git push origin main
```

#### 4. **Verification** (5 minutes)
- Check pipeline status in GitLab
- Verify application health via ALB endpoint
- Test frontend functionality

### 🔗 **External Resources**

#### 📚 **Documentation Links**
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [AWS WAF Documentation](https://docs.aws.amazon.com/waf/)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)

#### 🛠️ **Tools & Resources**
- [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform Installation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Docker Installation](https://docs.docker.com/get-docker/)
- [Node.js Installation](https://nodejs.org/en/download/)
- [Java 21 Installation](https://adoptium.net/)

### ❓ **Troubleshooting & Support**

#### 🔍 **Common Issues**
- **Deployment Failures**: Check GitLab CI/CD logs, Terraform outputs
- **Application Issues**: Review CloudWatch logs, ECS service status
- **Performance Issues**: Monitor CloudWatch metrics, ALB target health
- **Security Issues**: Review WAF logs, security group configurations

#### 🆘 **Get Help**
- **📖 Read Documentation**: [Architecture Guide](./ARCHITECTURE.md)
- **🐛 Create Issue**: Use GitHub/GitLab issue tracker
- **📋 Check Logs**: CloudWatch logs for runtime issues
- **📧 Contact Team**: Reach out to DevOps team

---

**🔝 [Back to Top](#-project-navigation--documentation-index)**

**Last Updated:** $(date)
**Version:** 2.0.0 (Enhanced with S3 deployment and comprehensive documentation)
**Maintainer:** DevOps Team