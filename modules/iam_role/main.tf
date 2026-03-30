# 1. IAM Role — Glue service can assume this role
resource "aws_iam_role" "glue_role" {
  name = "${var.role_name}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment
  }
}

# 2. IAM Policy — what the role is allowed to do
resource "aws_iam_policy" "glue_policy" {
  name = "${var.role_name}-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # S3 access
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        # Glue catalog access
        Effect   = "Allow"
        Action   = ["glue:*"]
        Resource = ["*"]
      },
      {
        # CloudWatch logging
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# 3. Attach policy to role
resource "aws_iam_role_policy_attachment" "glue_attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}