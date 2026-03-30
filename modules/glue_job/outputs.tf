output "job_name" {
  description = "Name of the Glue job"
  value       = aws_glue_job.this.name
}

output "job_id" {
  description = "ID of the Glue job"
  value       = aws_glue_job.this.id
}