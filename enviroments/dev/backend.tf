# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "dev/terraform.tfstate"      # ← dev state
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}