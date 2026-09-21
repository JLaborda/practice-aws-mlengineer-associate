# Lab 02 — S3 public access + bucket policy
# Relajar Block Public Access y permitir GetObject anónimo

resource "aws_s3_bucket" "lab" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket = aws_s3_bucket.lab.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.lab.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Statement1"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.lab.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.lab]
}

resource "aws_s3_bucket_versioning" "lab" {
  bucket = aws_s3_bucket.lab.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "coffee" {
  bucket       = aws_s3_bucket.lab.id
  key          = "coffee.jpg"
  source       = var.coffee_image_path
  content_type = "image/jpeg"
}

resource "aws_s3_object" "beach" {
  bucket       = aws_s3_bucket.lab.id
  key          = "images/beach.jpg"
  source       = var.beach_image_path
  content_type = "image/jpeg"
}
