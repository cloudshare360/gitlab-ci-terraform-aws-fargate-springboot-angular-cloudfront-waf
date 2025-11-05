* [Home](/)
* Overview
  * [Architecture Overview](ARCHITECTURE.md#architecture-vision)
  * [Technology Stack](ARCHITECTURE.md#technology-stack)
  * [Deployment Modes](ARCHITECTURE.md#deployment-modes)
* System Architecture
  * [High-Level Architecture](ARCHITECTURE.md#high-level-architecture)
  * [AWS Infrastructure](ARCHITECTURE.md#aws-infrastructure)
  * [Security Architecture](ARCHITECTURE.md#security-architecture)
* Deployment (Execution Order)
  * [1. Prerequisites](ARCHITECTURE.md#prerequisites)
  * [2. Terraform Structure](ARCHITECTURE.md#terraform-structure)
  * [3. Deploy Infrastructure (Terraform)](ARCHITECTURE.md#deployment-steps)
  * [4. Build Applications](ARCHITECTURE.md#pipeline-stages)
  * [5. Deploy Backend (Fargate)](ARCHITECTURE.md#fargate-container-deployment)
  * [6. Deploy Frontend - S3 Static](ARCHITECTURE.md#s3-static-site-deployment)
  * [7. Deploy Frontend - Container (Fargate)](ARCHITECTURE.md#fargate-container-deployment)
  * [8. Verify & Monitoring](ARCHITECTURE.md#deployment-flow)
* CI/CD Pipeline
  * [Pipeline Overview](ARCHITECTURE.md#pipeline-overview)
  * [Pipeline Stages](ARCHITECTURE.md#pipeline-stages)
  * [Deployment Flow](ARCHITECTURE.md#deployment-flow)
* Application Architecture
  * [Backend Architecture](ARCHITECTURE.md#backend-architecture)
  * [Frontend Architecture](ARCHITECTURE.md#frontend-architecture)
  * [Database Design](ARCHITECTURE.md#database-design)
* Infrastructure as Code
  * [Terraform Structure](ARCHITECTURE.md#terraform-structure)
  * [Module Dependencies](ARCHITECTURE.md#module-dependencies)
  * [Environment Management](ARCHITECTURE.md#environment-management)
* Monitoring & Security
  * [Monitoring and Observability](ARCHITECTURE.md#monitoring-and-observability)
  * [Security Implementation](ARCHITECTURE.md#security-implementation)
* Project Structure
  * [Repository Layout](ARCHITECTURE.md#repository-layout)
* Additional Docs
  * [Navigation Index](NAVIGATION.md)
  * [Root README](../README.md)
