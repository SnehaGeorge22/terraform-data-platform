resource "aws_glue_job" "this" {
  name         = "${var.job_name}-${var.environment}"
  role_arn     = var.role_arn
  glue_version = var.glue_version

  # Script location in S3
  command {
    name            = "glueetl"
    script_location = var.script_location
    python_version  = "3"
  }

  # Worker config
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers

  # Default job parameters
  default_arguments = merge(
    {
      "--job-bookmark-option"        = "job-bookmark-enable"
      "--enable-metrics"             = "true"
      "--enable-continuous-cloudwatch-log" = "true"
      "--environment"                = var.environment
    },
    var.job_parameters    # ← merge with any extra params passed in
  )

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}