variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "environment" {
  description = "Environment: dev, staging, prod"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of S3 bucket Glue can access"
  type        = string
}