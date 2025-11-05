variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "api_domain_name" {
  description = "Domain name for API redirects"
  type        = string
  default     = ""
}

variable "enable_logging" {
  description = "Enable S3 access logging"
  type        = bool
  default     = true
}

variable "create_backend_bucket" {
  description = "Create additional bucket for backend file storage"
  type        = bool
  default     = true
}