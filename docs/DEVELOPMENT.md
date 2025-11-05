# 🔧 Development Environment Setup Guide

This guide provides comprehensive instructions for setting up the development environment for the Fargate Spring Boot Angular application.

## 📋 Prerequisites

### System Requirements
- **Operating System**: Windows 10+, macOS 10.14+, or Ubuntu 18.04+
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: Minimum 20GB free space
- **Internet**: Stable broadband connection

### Required Software

#### 1. Java Development Kit (JDK) 21
```bash
# Install using SDKMAN (recommended)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.1-oracle

# Verify installation
java -version
javac -version
```

#### 2. Node.js 18+ and npm
```bash
# Install using Node Version Manager (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18

# Verify installation
node --version
npm --version
```

#### 3. Angular CLI
```bash
npm install -g @angular/cli@17
ng version
```

#### 4. Docker and Docker Compose
```bash
# Install Docker Desktop (Windows/macOS)
# Or install Docker Engine (Linux)
# Download from: https://docs.docker.com/get-docker/

# Verify installation
docker --version
docker-compose --version
```

#### 5. Terraform
```bash
# Install using package manager
# macOS with Homebrew
brew install terraform

# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify installation
terraform --version
```

#### 6. AWS CLI
```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

#### 7. Git
```bash
# Usually pre-installed, but if not:
# Ubuntu/Debian
sudo apt install git

# macOS
brew install git

# Verify installation
git --version
```

### IDE Setup

#### IntelliJ IDEA (Recommended for Java)
1. Download IntelliJ IDEA Community or Ultimate
2. Install Spring Boot plugin
3. Install Docker plugin
4. Configure Java SDK 21

#### Visual Studio Code (Recommended for Angular)
```bash
# Install VS Code extensions
code --install-extension ms-vscode.vscode-spring-initializr
code --install-extension pivotal.vscode-spring-boot
code --install-extension angular.ng-template
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension hashicorp.terraform
code --install-extension ms-azuretools.vscode-docker
```

## 🔧 Local Development Setup

### 1. Clone the Repository
```bash
git clone https://gitlab.com/cloudshare360/gitlab-ci-terraform-aws-fargate-springboot-angular-cloudfront-waf.git
cd gitlab-ci-terraform-aws-fargate-springboot-angular-cloudfront-waf
```

### 2. Backend Setup (Spring Boot)

#### Install Dependencies
```bash
cd backend
./mvnw clean install -DskipTests
```

#### Configure Database
```bash
# Install MySQL locally (optional, Docker recommended)
# macOS
brew install mysql
brew services start mysql

# Ubuntu
sudo apt install mysql-server
sudo systemctl start mysql

# Create database
mysql -u root -p
CREATE DATABASE fargatedb;
CREATE USER 'fargate_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON fargatedb.* TO 'fargate_user'@'localhost';
FLUSH PRIVILEGES;
```

#### Run with Docker (Recommended)
```bash
# Start MySQL in Docker
docker run --name mysql-dev \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=fargatedb \
  -e MYSQL_USER=fargate_user \
  -e MYSQL_PASSWORD=password \
  -p 3306:3306 \
  -d mysql:8.0
```

#### Environment Configuration
Create `backend/src/main/resources/application-dev.properties`:
```properties
# Development configuration
spring.datasource.url=jdbc:mysql://localhost:3306/fargatedb
spring.datasource.username=fargate_user
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
logging.level.com.cloudshare360.api=DEBUG
```

#### Run Backend
```bash
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Backend will be available at: http://localhost:8080

### 3. Frontend Setup (Angular)

#### Install Dependencies
```bash
cd frontend
npm install
```

#### Environment Configuration
Update `frontend/src/environments/environment.ts`:
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080'
};
```

#### Run Frontend
```bash
cd frontend
npm start
```

Frontend will be available at: http://localhost:4200

### 4. Full Stack with Docker Compose

Create `docker-compose.dev.yml` in project root:
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: fargatedb
      MYSQL_USER: fargate_user
      MYSQL_PASSWORD: password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      DB_URL: jdbc:mysql://mysql:3306/fargatedb
      DB_USERNAME: fargate_user
      DB_PASSWORD: password
    depends_on:
      - mysql

  frontend:
    build: ./frontend
    ports:
      - "4200:80"
    depends_on:
      - backend

volumes:
  mysql_data:
```

#### Run Full Stack
```bash
docker-compose -f docker-compose.dev.yml up --build
```

## 🧪 Testing Setup

### Backend Testing
```bash
cd backend

# Unit tests
./mvnw test

# Integration tests
./mvnw integration-test

# Coverage report
./mvnw jacoco:report
```

### Frontend Testing
```bash
cd frontend

# Unit tests
npm test

# E2E tests
npm run e2e

# Coverage
npm run test:coverage
```

## 🔍 Code Quality Tools

### Backend Code Quality
```bash
cd backend

# Checkstyle
./mvnw checkstyle:check

# SpotBugs
./mvnw spotbugs:check

# PMD
./mvnw pmd:check
```

### Frontend Code Quality
```bash
cd frontend

# ESLint
npm run lint

# Fix lint issues
npm run lint:fix

# Security audit
npm audit
npm audit fix
```

## 🔧 Development Tools

### Useful Scripts

Create `scripts/dev-setup.sh`:
```bash
#!/bin/bash
echo "Setting up development environment..."

# Start services
docker-compose -f docker-compose.dev.yml up -d mysql

# Wait for MySQL to be ready
echo "Waiting for MySQL to start..."
sleep 30

# Run backend
cd backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev &

# Run frontend
cd ../frontend && npm start &

echo "Development environment is ready!"
echo "Backend: http://localhost:8080"
echo "Frontend: http://localhost:4200"
```

### Debug Configuration

#### IntelliJ IDEA Debug Configuration
1. Go to Run → Edit Configurations
2. Add New → Spring Boot
3. Set Main class: `com.cloudshare360.api.FargateSpringbootApiApplication`
4. Set VM options: `-Dspring.profiles.active=dev`
5. Set Program arguments if needed

#### VS Code Debug Configuration
Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Spring Boot App",
      "request": "launch",
      "mainClass": "com.cloudshare360.api.FargateSpringbootApiApplication",
      "projectName": "fargate-springboot-api",
      "args": "--spring.profiles.active=dev"
    },
    {
      "name": "ng serve",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/frontend/node_modules/@angular/cli/bin/ng",
      "args": ["serve"],
      "options": {
        "cwd": "${workspaceFolder}/frontend"
      }
    }
  ]
}
```

## 📊 Monitoring and Observability

### Local Monitoring Setup

#### Prometheus and Grafana
Create `docker-compose.monitoring.yml`:
```yaml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

#### Application Metrics
Backend already includes Spring Actuator. Access metrics at:
- Health: http://localhost:8080/actuator/health
- Metrics: http://localhost:8080/actuator/metrics
- Info: http://localhost:8080/actuator/info

## 🔄 Git Workflow

### Pre-commit Hooks
Install pre-commit hooks:
```bash
# Install pre-commit
pip install pre-commit

# Setup hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### Branch Strategy
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create merge request
git push origin feature/your-feature-name
```

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :8080
kill -9 <PID>

# Or use different port
./mvnw spring-boot:run -Dserver.port=8081
```

#### Maven Dependencies
```bash
# Clear Maven cache
./mvnw dependency:purge-local-repository

# Reimport dependencies
./mvnw clean install
```

#### Node Modules Issues
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

#### Docker Issues
```bash
# Clean Docker
docker system prune -a

# Rebuild images
docker-compose down
docker-compose up --build
```

## 📚 Additional Resources

### Documentation
- [Spring Boot Reference](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Angular Documentation](https://angular.io/docs)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Learning Resources
- [Spring Boot Tutorials](https://spring.io/guides)
- [Angular Tutorials](https://angular.io/tutorial)
- [Docker Getting Started](https://docs.docker.com/get-started/)

### Community
- [Spring Community](https://spring.io/community)
- [Angular Community](https://angular.io/community)
- [Stack Overflow](https://stackoverflow.com/)

---

Happy coding! 🚀