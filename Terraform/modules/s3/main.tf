resource "aws_s3_bucket" "upload_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.upload_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.upload_bucket
  ]
}

resource "aws_s3_bucket_versioning" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
