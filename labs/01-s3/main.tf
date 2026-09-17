# Lab 01 — S3 basics (Udemy console tasks → Terraform)
# Tasks 1–4: bucket, coffee.jpg at root, beach.jpg under images/
# Task 5 (delete images/): remove aws_s3_object.beach and run terraform apply

resource "aws_s3_bucket" "lab" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket = aws_s3_bucket.lab.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
