# environments/staging/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "staging/terraform.tfstate"     # ← staging state
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}