# 1. Create RAW bucket
module "raw_bucket" {
  source       = "./modules/s3_bucket"
  bucket_name  = "my-data-platform-raw"
  environment  = var.environment
}

# 2. Create CURATED bucket
module "curated_bucket" {
  source       = "./modules/s3_bucket"
  bucket_name  = "my-data-platform-curated"
  environment  = var.environment
}

# 3. Create SCRIPTS bucket
module "scripts_bucket" {
  source            = "./modules/s3_bucket"
  bucket_name       = "my-data-platform-scripts"
  environment       = var.environment
  enable_versioning = false    # ← scripts don't need versioning
}

# 4. Create IAM Role (passing raw bucket ARN)
module "glue_iam_role" {
  source        = "./modules/iam_role"
  role_name     = "glue-etl-role"
  environment   = var.environment
  s3_bucket_arn = module.raw_bucket.bucket_arn
}