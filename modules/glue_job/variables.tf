variable "job_name" {
  description = "Name of the Glue job"
  type        = string
}

variable "environment" {
  description = "Environment: dev, staging, prod"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the Glue job"
  type        = string
  # ← will come from iam_role module output
}

variable "script_location" {
  description = "S3 path to the PySpark script"
  type        = string
  # ← will come from s3_bucket module output
}

variable "glue_version" {
  description = "Glue version to use"
  type        = string
  default     = "4.0"
}

variable "worker_type" {
  description = "G.1X, G.2X, G.4X"
  type        = string
  default     = "G.1X"
}

variable "number_of_workers" {
  description = "Number of DPU workers"
  type        = number
  default     = 2
}

variable "job_parameters" {
  description = "Additional parameters passed to the Glue job"
  type        = map(string)
  default     = {}
}