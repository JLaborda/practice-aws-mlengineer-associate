# Lab 02 — S3 public access + bucket policy
# Relajar Block Public Access y permitir GetObject anónimo

#1. Creating buckets
resource "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = var.destination_bucket_name
}

#2. Adding Versioning to buckets
resource "aws_s3_bucket_versioning" "source_bucket" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "destination_bucket" {
  bucket = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Creating rols for replication
data "aws_iam_policy_document" "replication_assume" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.replication_assume.json
}

# 4. Rol permissions for replication
data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.source_bucket.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${aws_s3_bucket.source_bucket.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${aws_s3_bucket.destination_bucket.arn}/*"]
  }
}
# Attach the policy to the role
resource "aws_iam_role_policy" "replication_policy" {
  name = "s3-replication-policy"
  role = aws_iam_role.replication_role.id
  policy = data.aws_iam_policy_document.replication.json
}

# 5. Create the replication configuration
resource "aws_s3_bucket_replication_configuration" "source_bucket" {
  depends_on = [
    aws_s3_bucket_versioning.source_bucket,
    aws_s3_bucket_versioning.destination_bucket,
  ]
  role   = aws_iam_role.replication_role.arn
  bucket = aws_s3_bucket.source_bucket.id
  rule {
    id     = "replicate-all"
    status = "Enabled"
    # vacío = todo el bucket (V2 rules)
    filter {}
    delete_marker_replication {
      status = "Disabled" # o Enabled, según el lab
    }
    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"
    }
  } 
}
# 6. Upload the files to the source bucket
resource "aws_s3_object" "coffee" {
  bucket       = aws_s3_bucket.source_bucket.id
  key          = "coffee.jpg"
  source       = var.coffee_image_path
  content_type = "image/jpeg"
}

resource "aws_s3_object" "beach" {
  bucket       = aws_s3_bucket.source_bucket.id
  key          = "images/beach.jpg"
  source       = var.beach_image_path
  content_type = "image/jpeg"
}
